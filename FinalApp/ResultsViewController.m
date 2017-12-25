//
//  ResultsViewController.m
//  FinalApp
//
//  Created by Mehr Sethi on 11/21/17.
//  Copyright © 2017 Mehr Sethi. All rights reserved.
//

#import "ResultsViewController.h"
#include "UserModel.h"
#include "ProductModel.h"
#include "ScanViewController.h"
#include "TranslationModel.h"

@interface ResultsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *fadedImage;
@property (weak, nonatomic) IBOutlet UIImageView *marginImage;

@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) ProductModel *product;
@property (strong, nonatomic) NSMutableArray *noFoods;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonHome;
@property (weak, nonatomic) IBOutlet UILabel *labelQuestionableIngredients;
@property (weak, nonatomic) IBOutlet UIButton *buttonScanAnother;
@property (weak, nonatomic) IBOutlet UITableView *tableViewQuestionableIngredients;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //localization
    _buttonHome.title = NSLocalizedString(@"Home", nil);
    [self.buttonScanAnother setTitle:NSLocalizedString(@"Scan Another", nil) forState:UIControlStateNormal];
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"Match", nil)];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"Ingredients", nil)];
    
    // getting the relevant info from the models
    self.user = [UserModel sharedModel];
    self.product = [ProductModel sharedModel];
    self.noFoods = [[NSMutableArray alloc] init];
    self.noFoods = [self.product calculateSuitability];
    
    //translate the questionable ingredients
    NSString* currentlang = [[[NSLocale preferredLanguages] firstObject] substringToIndex:2];
    for (int i=0; i<self.noFoods.count; i++){
        NSMutableArray* tempArray = [[self.noFoods[i] componentsSeparatedByString:@" "] mutableCopy];
        for (int j=0; j<tempArray.count; j++){
            tempArray[j] = [TranslationModel translateJSON:tempArray[j] targetLang:currentlang sourceLang:self.product.sourceLang];
        }
        self.noFoods[i] = [tempArray componentsJoinedByString:@" "];
    }

    // if the suitability is 100, update the label accordingly
    // also add in a bolded version of the product's name to the label
    NSString *bigString = [[NSString alloc] init];
    if ([self.product getSuitability] == 100){
        bigString = [NSString stringWithFormat:NSLocalizedString(@"This product is perfect for you!", nil), self.product.getName];
        if (@available(iOS 11.0, *)) {
            [_tableViewQuestionableIngredients setDragInteractionEnabled:NO];
        } else {
            // Fallback on earlier versions
        }
        if (@available(iOS 11.0, *)) {
            [_tableViewQuestionableIngredients setAlpha:0.5];
        } else {
            // Fallback on earlier versions
        }
    }
    else{
        bigString = [NSString stringWithFormat:NSLocalizedString(@"%@ contains the following ingredients that don't match your dietary preferences- ", nil), self.product.getName];
    }
    NSMutableAttributedString *yourAttributedString = [[NSMutableAttributedString alloc] initWithString:bigString];
    NSString *boldString = self.product.getName;
    NSRange boldRange = [bigString rangeOfString:boldString];
    [yourAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:boldRange];
    [_labelQuestionableIngredients setAttributedText: yourAttributedString];
    
}

- (void)viewWillAppear:(BOOL)animated{
    // animate the overlay views resizing according to the suitability of the product
    [UIView animateWithDuration:2.0 animations:^{
        self.fadedImage.frame = CGRectMake(16+(self.product.getSuitability*343/100), 76, (343-(self.product.getSuitability*343/100.0)), 127.0f);
        self.marginImage.frame = CGRectMake(16+(self.product.getSuitability*343/100), 72, 3.0f, 136.0f);
        
    }];
}

// methods for the table view
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noFoods.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoFoodCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.noFoods[indexPath.row];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

// when home is tapped, dismiss both the current view controller and the presenting view controller (which is the scan view controller)
- (IBAction)homeDidTapped:(UIBarButtonItem *)sender {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

// when scan another is tapped, dimsiss the current view controller
- (IBAction)scanAnotherDidTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
