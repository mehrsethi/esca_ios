//
//  ViewController.m
//  FinalApp
//
//  Created by Mehr Sethi on 11/21/17.
//  Copyright © 2017 Mehr Sethi. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"
#import "SignUpViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) UserModel *user;

@property (weak, nonatomic) IBOutlet UILabel *textEditProfile;
@property (weak, nonatomic) IBOutlet UIButton *buttonStartScanning;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [UserModel sharedModel];
    
    [self loadImage];
    
    self.textEditProfile.text = NSLocalizedString(@"EDIT PROFILE", nil);
    [self.buttonStartScanning setTitle:NSLocalizedString(@"START SCANNING!", nil) forState:UIControlStateNormal];
    [self.buttonStartScanning.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

-(void)viewDidAppear:(BOOL)animated{
    // if the app is being used for the first time, launch the sign up view controller
    if ([self.user.getName isEqualToString:@""]){
        SignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        [self presentViewController:signUpViewController animated:NO completion:nil];
    }
}

// if the user's doesn't have a set image, use the default
// otherwise use the saved image
- (void)loadImage{
    if (![[self.user getImagePath] isEqualToString:@""]){
        self.profileImage.image = [UIImage imageWithContentsOfFile:[self.user getImagePath]];
        if ([UIImage imageWithContentsOfFile:[self.user getImagePath]] == NULL){
            self.profileImage.image = [UIImage imageNamed:@"profile_placeholder"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
