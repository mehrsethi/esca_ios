//
//  SignUpViewController.m
//  FinalApp
//
//  Created by Mehr Sethi on 11/21/17.
//  Copyright © 2017 Mehr Sethi. All rights reserved.
//

#import "SignUpViewController.h"
#include "UserModel.h"
#include "StringValues.h"
#import "ViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (weak, nonatomic) IBOutlet UIPickerView *dietPicker;
@property (strong, nonatomic) NSArray *dietArray;

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textAge;

@property (weak, nonatomic) IBOutlet UISwitch *switchSoybeans;
@property (weak, nonatomic) IBOutlet UISwitch *switchCrustacean;
@property (weak, nonatomic) IBOutlet UISwitch *switchTreeNuts;
@property (weak, nonatomic) IBOutlet UISwitch *switchSulfites;
@property (weak, nonatomic) IBOutlet UISwitch *switchPeanuts;
@property (weak, nonatomic) IBOutlet UISwitch *switchMilk;
@property (weak, nonatomic) IBOutlet UISwitch *switchFish;
@property (weak, nonatomic) IBOutlet UISwitch *switchGluten;
@property (weak, nonatomic) IBOutlet UISwitch *switchWheat;
@property (weak, nonatomic) IBOutlet UISwitch *switchEggs;
@property (weak, nonatomic) IBOutlet UISwitch *switchGarlic;
@property (weak, nonatomic) IBOutlet UISwitch *switchRice;
@property (weak, nonatomic) IBOutlet UISwitch *switchOats;

@property (weak, nonatomic) IBOutlet UISwitch *switchGout;
@property (weak, nonatomic) IBOutlet UISwitch *switchHighCholesterol;
@property (weak, nonatomic) IBOutlet UISwitch *switchKidneyDiseases;
@property (weak, nonatomic) IBOutlet UISwitch *switchLactoseIntolerance;
@property (weak, nonatomic) IBOutlet UISwitch *switchOsteoporosis;
@property (weak, nonatomic) IBOutlet UISwitch *switchCeliacDisease;
@property (weak, nonatomic) IBOutlet UISwitch *switchDiabetes;

@property (strong, nonatomic) UserModel *user;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelCheckAllergies;
@property (weak, nonatomic) IBOutlet UILabel *labelSoyabeans;
@property (weak, nonatomic) IBOutlet UILabel *labelCrustacean;
@property (weak, nonatomic) IBOutlet UILabel *labelTreeNuts;
@property (weak, nonatomic) IBOutlet UILabel *labelSulfites;
@property (weak, nonatomic) IBOutlet UILabel *labelPeanuts;
@property (weak, nonatomic) IBOutlet UILabel *labelMilk;
@property (weak, nonatomic) IBOutlet UILabel *labelFish;
@property (weak, nonatomic) IBOutlet UILabel *labelGluten;
@property (weak, nonatomic) IBOutlet UILabel *labelWheat;
@property (weak, nonatomic) IBOutlet UILabel *labelEggs;
@property (weak, nonatomic) IBOutlet UILabel *labelGarlic;
@property (weak, nonatomic) IBOutlet UILabel *labelRice;
@property (weak, nonatomic) IBOutlet UILabel *labelOats;
@property (weak, nonatomic) IBOutlet UILabel *labelDietPreference;
@property (weak, nonatomic) IBOutlet UILabel *labelMedicalConditions;
@property (weak, nonatomic) IBOutlet UILabel *labelGout;
@property (weak, nonatomic) IBOutlet UILabel *labelHighCholesterol;
@property (weak, nonatomic) IBOutlet UILabel *labelKidneyDiseases;
@property (weak, nonatomic) IBOutlet UILabel *labelLactoseIntolerance;
@property (weak, nonatomic) IBOutlet UILabel *labelOsteoporosis;
@property (weak, nonatomic) IBOutlet UILabel *labelCeliacDisease;
@property (weak, nonatomic) IBOutlet UILabel *labelDiabetes;
@property (weak, nonatomic) IBOutlet UIButton *buttonContinue;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonBack;

@end

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // localization
    _labelName.text = NSLocalizedString(@"Name: ", nil);
    _labelAge.text = NSLocalizedString(@"Age: ", nil);
    _labelCheckAllergies.text = NSLocalizedString(@"Check any allergies that you have: ", nil);
    _labelSoyabeans.text = NSLocalizedString(@"Soybeans", nil);
    _labelMilk.text = NSLocalizedString(@"Milk", nil);
    _labelEggs.text = NSLocalizedString(@"Eggs", nil);
    _labelFish.text = NSLocalizedString(@"Fish", nil);
    _labelCrustacean.text = NSLocalizedString(@"Crustacean", nil);
    _labelTreeNuts.text = NSLocalizedString(@"Tree nuts", nil);
    _labelPeanuts.text = NSLocalizedString(@"Peanuts", nil);
    _labelWheat.text = NSLocalizedString(@"Wheat", nil);
    _labelRice.text = NSLocalizedString(@"Rice", nil);
    _labelGarlic.text = NSLocalizedString(@"Garlic", nil);
    _labelOats.text = NSLocalizedString(@"Oats", nil);
    _labelSulfites.text = NSLocalizedString(@"Sulfites", nil);
    _labelGluten.text = NSLocalizedString(@"Gluten", nil);
    _labelDietPreference.text = NSLocalizedString(@"Select your diet preference: ", nil);
    _labelMedicalConditions.text = NSLocalizedString(@"Check any chronic medical conditions you have: ", nil);
    _labelDiabetes.text = NSLocalizedString(@"Diabetes", nil);
    _labelKidneyDiseases.text = NSLocalizedString(@"Kidney diseases", nil);
    _labelHighCholesterol.text = NSLocalizedString(@"High cholesterol", nil);
    _labelGout.text = NSLocalizedString(@"Gout", nil);
    _labelCeliacDisease.text = NSLocalizedString(@"Celiac disease", nil);
    _labelLactoseIntolerance.text = NSLocalizedString(@"Lactose intolerance", nil);
    _labelOsteoporosis.text = NSLocalizedString(@"Osteoporosis", nil);
    [self.continueButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
    _buttonBack.title = NSLocalizedString(@"Back", nil);
    
    self.dietArray = @[NSLocalizedString(@"ovo-vegetarian", nil), NSLocalizedString(@"lacto-vegetarian", nil), NSLocalizedString(@"vegan", nil), NSLocalizedString(@"vegetarian", nil), NSLocalizedString(@"No preference", nil)];
    
    self.user = [UserModel sharedModel];
    
    //update the view to show an existing user's information
    if (![self.user.getImagePath isEqualToString:@""]){
        self.profileImage.image = [UIImage imageWithContentsOfFile:[self.user getImagePath]];
        if ([UIImage imageWithContentsOfFile:[self.user getImagePath]] == NULL){
            self.profileImage.image = [UIImage imageNamed:@"profile_placeholder"];
        }
    }
    
    if (![self.user.getName isEqual:@""]){
        self.textName.text = self.user.getName;
    }
    if (self.user.getAge != 0){
        self.textAge.text = [NSString stringWithFormat:@"%ld", self.user.getAge];
    }
    
    for (int i=0; i<self.user.getAllergiesArray.count; i++){
        if ([self.user.getAllergiesArray[i]  isEqual:SOYBEANS]){
            [self.switchSoybeans setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:CRUSTACEAN]){
            [self.switchCrustacean setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:TREE_NUTS]){
            [self.switchTreeNuts setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:SULPHITES]){
            [self.switchSulfites setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:PEANUTS]){
            [self.switchPeanuts setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:MILK]){
            [self.switchMilk setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:FISH]){
            [self.switchFish setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:GLUTEN]){
            [self.switchGluten setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:WHEAT]){
            [self.switchWheat setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:EGGS]){
            [self.switchEggs setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:GARLIC]){
            [self.switchGarlic setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:RICE]){
            [self.switchRice setOn:YES];
        }
        if ([self.user.getAllergiesArray[i]  isEqual:OATS]){
            [self.switchOats setOn:YES];
        }
    }
    
    for (int i=0; i<self.user.getMedicalArray.count; i++){
        if ([self.user.getMedicalArray[i] isEqual:GOUT]){
            [self.switchGout setOn:YES];
        }
        if ([self.user.getMedicalArray[i] isEqual:HIGH_CHOLESTEROL]){
            [self.switchHighCholesterol setOn:YES];
        }
        if ([self.user.getMedicalArray[i] isEqual:KIDNEY_DISEASES]){
            [self.switchKidneyDiseases setOn:YES];
        }
        if ([self.user.getMedicalArray[i] isEqual:LACTOSE_INTOLERANCE]){
            [self.switchLactoseIntolerance setOn:YES];
        }
        if ([self.user.getMedicalArray[i] isEqual:OSTEOPOROSIS]){
            [self.switchOsteoporosis setOn:YES];
        }
        if ([self.user.getMedicalArray[i] isEqual:CELIAC_DISEASE]){
            [self.switchCeliacDisease setOn:YES];
        }
        if ([self.user.getMedicalArray[i] isEqual:DIABETES]){
            [self.switchDiabetes setOn:YES];
        }
    }
    
    for (int j=0; j<self.dietArray.count; j++){
        if ([self.dietArray[j] isEqual:self.user.getDietPreference]){
            [self.dietPicker selectRow:j inComponent:0 animated:YES];
        }
    }
    
    //check if the continue button should be enabled
    [self enableContinue];
}

// methods for setting up the picker view
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dietArray.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dietArray[row];
}

// responding to user edits
- (IBAction)textNameDidFinishEditing:(UITextField *)sender {
    [self enableContinue];
}

- (IBAction)textAgeDidFinishEditing:(UITextField *)sender {
    [self enableContinue];
}

- (IBAction)textNameDidEndOnExit:(UITextField *)sender {
    [self.textName resignFirstResponder];
    [self enableContinue];
}

- (IBAction)textAgeDidEndOnExit:(UITextField *)sender {
    [self.textAge resignFirstResponder];
    [self enableContinue];
}

// when continue is tapped, dismiss the view controller after updating the user model
- (IBAction)continueDidTapped:(UIButton *)sender {
    [self whatWasPicked];
    [(ViewController*)self.presentingViewController loadImage];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

// when back is tapped, dismiss view controller
- (IBAction)backDidTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

// enable continue if text name and text age have lengths greater than 0
- (void) enableContinue{
    if (self.textName.text.length > 0 && self.textAge.text.length > 0){
        [self.continueButton setEnabled:YES];
        [self.continueButton setAlpha:1];
    }
    else{
        [self.continueButton setEnabled:NO];
        [self.continueButton setAlpha:0.5];
    }
}

// updating the user model with the information that was edited by the user
- (void) whatWasPicked{
    [self.user clearAllergies];
    [self.user clearMedical];
    
    [self.user setName:self.textName.text];
    [self.user setAge:[self.textAge.text integerValue]];
    
    NSInteger row = [self.dietPicker selectedRowInComponent:0];
    NSString *diet = self.dietArray[row];
    [self.user setDietPreference:diet];
    
    if (self.switchSoybeans.isOn){
        [self.user addAllergy:SOYBEANS];
    }
    if (self.switchCrustacean.isOn){
        [self.user addAllergy:CRUSTACEAN];
    }
    if (self.switchTreeNuts.isOn){
        [self.user addAllergy:TREE_NUTS];
    }
    if (self.switchSulfites.isOn){
        [self.user addAllergy:SULPHITES];
    }
    if (self.switchPeanuts.isOn){
        [self.user addAllergy:PEANUTS];
    }
    if (self.switchMilk.isOn){
        [self.user addAllergy:MILK];
    }
    if (self.switchFish.isOn){
        [self.user addAllergy:FISH];
    }
    if (self.switchGluten.isOn){
        [self.user addAllergy:GLUTEN];
    }
    if (self.switchWheat.isOn){
        [self.user addAllergy:WHEAT];
    }
    if (self.switchEggs.isOn){
        [self.user addAllergy:EGGS];
    }
    if (self.switchGarlic.isOn){
        [self.user addAllergy:GARLIC];
    }
    if (self.switchRice.isOn){
        [self.user addAllergy:RICE];
    }
    if (self.switchOats.isOn){
        [self.user addAllergy:OATS];
    }
    
    if (self.switchGout.isOn){
        [self.user addMedical:GOUT];
    }
    if (self.switchHighCholesterol.isOn){
        [self.user addMedical:HIGH_CHOLESTEROL];
    }
    if (self.switchKidneyDiseases.isOn){
        [self.user addMedical:KIDNEY_DISEASES];
    }
    if (self.switchLactoseIntolerance.isOn){
        [self.user addMedical:LACTOSE_INTOLERANCE];
    }
    if (self.switchOsteoporosis.isOn){
        [self.user addMedical:OSTEOPOROSIS];
    }
    if (self.switchCeliacDisease.isOn){
        [self.user addMedical:CELIAC_DISEASE];
    }
    if (self.switchDiabetes.isOn){
        [self.user addMedical:DIABETES];
    }
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

// once the picker returns a photo, update the view and the model
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    self.profileImage.image = originalImage;
    [self saveImage:originalImage];
    
    // if the  image orientations if not correct, rectify it
    if (originalImage.imageOrientation != UIImageOrientationUp){
        UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, originalImage.scale);
        [originalImage drawInRect:(CGRect){0, 0, originalImage.size}];
        UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self saveImage:normalizedImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

// if the user clicks the image button, prompt them to select a source (camera or photo library)
// to use for choosing their profile picture
// launch an imagepicker according to their selection
- (IBAction)imagePickDidPressed:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Profile Photo"
                                                                             message:@"Choose which source to use for picking a photo"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *photosAction =  [UIAlertAction actionWithTitle:@"Photos Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{}];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{}];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:photosAction];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

// save the image locally
- (void)saveImage:(UIImage*) image{
    NSString *documentsDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filename = @"image.png";
    
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", documentsDirPath, filename];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    
    [self.user setImagePath:imagePath];
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
    // Pass the selected object to the new view controller.
}
*/

@end
