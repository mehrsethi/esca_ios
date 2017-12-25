//
//  ScanViewController.m
//  FinalApp
//
//  Created by Mehr Sethi on 11/21/17.
//  Copyright © 2017 Mehr Sethi. All rights reserved.
//

@import AVFoundation;
@import GoogleMobileVision;

#import "ScanViewController.h"
#import "ProductModel.h"
#import "TranslationModel.h"

@interface ScanViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UIView *placeholderView;

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property(nonatomic, strong) dispatch_queue_t videoDataOutputQueue;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic, strong) GMVDetector *barcodeDetector;
@property (nonatomic, strong) ProductModel *productModel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonHome;
@end

@implementation ScanViewController

// when home is tapped, dismiss the current view controller
- (IBAction)homeDidTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //localization
    _buttonHome.title = NSLocalizedString(@"Home", nil);
    
    //get product model
    self.productModel = [ProductModel sharedModel];
    
    _videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue",
                                                  NULL);
    
    //set up default camera settings
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetMedium;
    [self updateCameraSelection];
    
    //set up video processing
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    [self.session addOutput:self.videoDataOutput];
    
    //set up camera preview
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setFrame:self.placeholderView.layer.bounds];
    [self.placeholderView.layer addSublayer:self.previewLayer];
    
    //initialize barcode detector
    self.barcodeDetector = [GMVDetector detectorOfType:GMVDetectorTypeBarcode options:nil];
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //start session
    [self.session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //stop the session
    [self.session stopRunning];
}

- (void)viewDidUnload{
    //clean up
    if (self.videoDataOutput) {
        [self.session removeOutput:self.videoDataOutput];
    }
    self.videoDataOutput = nil;
    self.session = nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    UIImage *image = [GMVUtility sampleBufferTo32RGBA:sampleBuffer];
    AVCaptureDevicePosition devicePosition = AVCaptureDevicePositionBack;
    
    //detect barcode within the image using GMVDetector
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    GMVImageOrientation orientation = [GMVUtility
                                       imageOrientationFromOrientation:deviceOrientation
                                       withCaptureDevicePosition:devicePosition
                                       defaultDeviceOrientation:UIDeviceOrientationPortrait];
    NSDictionary *options = @{
                              GMVDetectorImageOrientation : @(orientation)
                              };
    
    NSArray<GMVBarcodeFeature *> *barcodes = [self.barcodeDetector featuresInImage:image
                                                                           options:options];
    NSLog(@"Detected %lu barcodes.", (unsigned long)barcodes.count);
    
    //attempt to parse the barcode using the Open Food Facts API
    dispatch_sync(dispatch_get_main_queue(), ^{
        for (GMVBarcodeFeature *barcode in barcodes) {
            [self JSONparse:[NSString stringWithFormat:@"%@/%@.json", @"https://world.openfoodfacts.org/api/v0/product", barcode.rawValue]];
        }
    });
}

#pragma mark - Camera setup

- (void)updateCameraSelection {
    [self.session beginConfiguration];
    
    //3emove old inputs
    NSArray *oldInputs = [self.session inputs];
    for (AVCaptureInput *oldInput in oldInputs) {
        [self.session removeInput:oldInput];
    }
    
    AVCaptureDeviceInput *input = [self captureDeviceInputForPosition:AVCaptureDevicePositionBack];
    if (!input) {
        //if failed, restore old inputs
        for (AVCaptureInput *oldInput in oldInputs) {
            [self.session addInput:oldInput];
        }
    } else {
        //if succeeded, set input and update connection states
        [self.session addInput:input];
    }
    [self.session commitConfiguration];
}

//get the input from a capture device that matches the required specifications
- (AVCaptureDeviceInput *)captureDeviceInputForPosition:(AVCaptureDevicePosition)desiredPosition {
    
//    AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInDualCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (device.position == desiredPosition) {
            NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                                error:&error];
            if (error) {
                NSLog(@"Could not initialize for AVMediaTypeVideo for device %@", device);
            } else if ([self.session canAddInput:input]) {
                return input;
            }
        }
    }
    return nil;
}

- (void) JSONparse:(NSString*) reqURL{
    NSError* error;
    NSData* jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:reqURL]];
    NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSString *statusJSON = [json objectForKey:@"status_verbose"];
    self.productModel.sourceLang = @"en";
    //if the product is found in the database, get the required details and update the product model
    if ([statusJSON isEqualToString:@"product found"]){
        NSMutableDictionary* product = [json objectForKey:@"product"];
        
        NSString* currentlang = [[[NSLocale preferredLanguages] firstObject] substringToIndex:2];
        NSString* lang = [product objectForKey:@"lang"];
        self.productModel.sourceLang = lang;
        
        //product name
        NSString* productName = [product objectForKey:@"product_name"];
        //make sure the name doesn't have any special charcaters
        NSData *data = [productName dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        productName = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSMutableArray* productNameArray = [[productName componentsSeparatedByString:@" "] mutableCopy];
        //if translations required, translate
        if (![lang isEqualToString:currentlang]){
            for (int i=0; i<productNameArray.count; i++){
                productNameArray[i] = [TranslationModel translateJSON:productNameArray[i] targetLang:currentlang sourceLang:lang];
            }
            productName = [productNameArray componentsJoinedByString:@" "];
        }
        //capitalize
        productName = [productName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[productName substringToIndex:1] uppercaseString]];
        [self.productModel setName:productName];
        
        // ingredients
        [self.productModel clearIngredients];
        NSMutableArray* ingredientsFromJSON = [product objectForKey:@"ingredients_tags"];
        for (int j=0; j<ingredientsFromJSON.count; j++){
            NSString* ingredient = [ingredientsFromJSON objectAtIndex:j];
            //make sure no special characters
            NSData *data = [ingredient dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            ingredient = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSMutableArray* ingredientNameArray = [[ingredient componentsSeparatedByString:@" "] mutableCopy];
            //translate if required
            if (![lang isEqualToString:currentlang]){
                for (int i=0; i<ingredientNameArray.count; i++){
                    ingredientNameArray[i] = [TranslationModel translateJSON:ingredientNameArray[i] targetLang:currentlang sourceLang:lang];
                }
                ingredient = [ingredientNameArray componentsJoinedByString:@" "];
            }
            [self.productModel addIngredient:ingredient];
        }
        
        //allergens
        [self.productModel clearAllergens];
        NSMutableArray* allergensFromJSON = [product objectForKey:@"allergens_tags"];
        for (int j=0; j<allergensFromJSON.count; j++){
            NSString* allergen = [allergensFromJSON objectAtIndex:j];
            allergen = [allergen substringFromIndex:3];
            //make sure no special charcaters
            NSData *data = [allergen dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            allergen = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSMutableArray* allergenNameArray = [[allergen componentsSeparatedByString:@" "] mutableCopy];
            if (![lang isEqualToString:currentlang]){
                //translate if required
                for (int i=0; i<allergenNameArray.count; i++){
                    allergenNameArray[i] = [TranslationModel translateJSON:allergenNameArray[i] targetLang:currentlang sourceLang:lang];
                }
                allergen = [allergenNameArray componentsJoinedByString:@" "];
            }
            [self.productModel addAllergen:allergen];
        }
        
        //diet
        [self.productModel clearDiet];
        NSMutableArray* dietsFromJSON = [product objectForKey:@"labels_tags"];
        for (int j=0; j<dietsFromJSON.count; j++){
            NSString* diet = [dietsFromJSON objectAtIndex:j];
            //make sure no special characters
            NSData *data = [diet dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            diet = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSMutableArray* dietNameArray = [[diet componentsSeparatedByString:@" "] mutableCopy];
            //translate if required
            if (![lang isEqualToString:currentlang]){
                for (int i=0; i<dietNameArray.count; i++){
                    dietNameArray[i] = [TranslationModel translateJSON:dietNameArray[i] targetLang:currentlang sourceLang:lang];
                }
                diet = [dietNameArray componentsJoinedByString:@" "];
            }
            [self.productModel addDietTag:diet];
        }
        
        //nutrients
        [self.productModel clearNutrition];
        NSMutableDictionary* nutrientsFromJSON = [product objectForKey:@"nutrient_levels"];
        NSString* sugarLevel = [nutrientsFromJSON objectForKey:@"sugars"];
        if (sugarLevel == nil)
        {
            [self.productModel.getNutritionDict setObject:@"" forKey:@"sugars"];
        }
        else{
            [self.productModel.getNutritionDict setObject:sugarLevel forKey:@"sugars"];
        }
        NSString* saltLevel = [nutrientsFromJSON objectForKey:@"salt"];
        if (saltLevel == nil)
        {
            [self.productModel.getNutritionDict setObject:@"" forKey:@"salt"];
        }
        else{
            [self.productModel.getNutritionDict setObject:saltLevel forKey:@"salt"];
        }
        NSString* fatLevel = [nutrientsFromJSON objectForKey:@"fat"];
        if (fatLevel == nil)
        {
            [self.productModel.getNutritionDict setObject:@"" forKey:@"fat"];
        }
        else{
            [self.productModel.getNutritionDict setObject:fatLevel forKey:@"fat"];
        }
        
        NSMutableDictionary* nutrimentsFromJSON = [product objectForKey:@"nutriments"];
        NSString* proteinLevel = [nutrimentsFromJSON objectForKey:@"proteins"];
        if (proteinLevel == nil)
        {
            [self.productModel.getNutritionDict setObject:@"" forKey:@"proteins"];
        }
        else{
            [self.productModel.getNutritionDict setObject:proteinLevel forKey:@"proteins"];
        }
    }
    //if product not found, pop up an alert for the user
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Product Not Found"
                                                                                 message:@"This product doesn't exist in our system. Please try again."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction =  [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:^{}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}
*/

@end
