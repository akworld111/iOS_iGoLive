//
//  VerificationViewController.m
//  hollyWood
//
//  Created by AK on 16/8/3..
//  Copyright © 2017 igo.live All rights reserved.
//

#import "VerificationViewController.h"
#import "LiveUser.h"
#import "Config.h"
#import <UMMobClick/MobClick.h>
#import "RecommendedFollowingViewController.h"
#import "CountryViewController.h"
#import "ProfileSetupViewController.h"

@interface VerificationViewController ()<UITextFieldDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) UILabel *labelCode;
@property (strong, nonatomic) NSTimer *codeTimer;
@property (strong, nonatomic) UIButton *buttonCode;
@property (assign, nonatomic) int time;
@property (strong, nonatomic) NSString *country;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *countryNumberLabel;

@property (strong, nonatomic) IBOutlet UILabel *termsLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;


@end

@implementation VerificationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.countryNumberLabel.text = [NSString stringWithFormat:@"+%@",self.countryNumber];
    [self.buttonCode setTitle:@"Send Code" forState:UIControlStateNormal];
    self.buttonCode.userInteractionEnabled = YES;
    self.buttonCode.alpha = 1;
    [self.codeTimer invalidate];
    self.codeTimer = nil;
    self.time = 60;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"Phone Verification";
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.backgroundColor = UIColorFromHexAlpha(col_btn_green, 1.0f);
    //[ViewModifierHelpers addGradientColorFadedSubLayerToNavBarView:navBar hexColorStart:col_verify_head_lt_green hexColorEnd:col_verify_head_drk_green];
    [self setUpTextFiled];
    self.countryNumberLabel.text = @"+1";
    self.countryNumber =@"1";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"By clicking \"Next\" you agree to the iGo.live Terms & Conditions"];
    [att setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(10.0)]} range:[@"By clicking \"Next\" you agree to the iGo.live Terms & Conditions" rangeOfString:@"Terms & Conditions"]];
    _termsLabel.attributedText = att;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.scrollView setContentSize:CGSizeMake(0, _window_height)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTextFiled {
    
    self.phoneTextField.backgroundColor = [UIColor whiteColor];
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.adjustsFontSizeToFitWidth = YES;
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.phoneTextField.frame.size.height)];
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.leftView = leftView;
    
    self.codeTextField.backgroundColor = [UIColor whiteColor];
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.adjustsFontSizeToFitWidth = YES;
    UIView* codeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.phoneTextField.frame.size.height)];
    self.codeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.codeTextField.leftView = codeLeftView;
    
    
    self.buttonCode = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80,28)];
    self.buttonCode.titleLabel.font = [UIFont systemFontOfSize:15];
    self.buttonCode.layer.masksToBounds = YES;
    self.buttonCode.layer.cornerRadius = 15;
  
//    self.buttonCode.backgroundColor = [UIColor colorWithRed:188/255.0 green:188/225.0 blue:188/255.0 alpha:1];
    [self.buttonCode setBackgroundImage:[UIImage imageNamed:@"sendCode"] forState:UIControlStateNormal];
    [self.buttonCode.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.buttonCode setTitle:@"Send Code" forState:UIControlStateNormal];
    [self.buttonCode addTarget:self action:@selector(pressButtonCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, self.buttonCode.frame.size.height)];
    [view addSubview: self.buttonCode];
    self.phoneTextField.rightViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.rightView = view;
    
}

- (void)pressButtonCode {
    [self.view endEditing:YES];
    self.time = 60;
    if (!(self.phoneTextField.text.length == 11 || self.phoneTextField.text.length == 10)){
        [MBProgressHUD showError:@"error format"];
    }
    else{
        [MBProgressHUD showMessage:@"Please wait"];
        [HttpService getSMSCodeWithMobile:self.phoneTextField.text country:self.countryNumber result:^(CommonReturn *commonReturn) {
            [MBProgressHUD hideHUD];
            if (commonReturn.state == 1) {
                [MBProgressHUD showSuccess:@"Text Message Sent Successfully"];
                if (self.codeTimer == nil) {
                    self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                }
            }
        }];
    }
}

- (void)countDown {
    self.buttonCode.alpha = 0.6;
    NSString* strTime = [NSString stringWithFormat:@"%ds",self.time];
    [self.buttonCode setTitle:strTime forState:UIControlStateNormal];
    self.buttonCode.userInteractionEnabled = NO;
    if (self.time <= 0) {
        [self.buttonCode setTitle:@"Send Code" forState:UIControlStateNormal];
        self.buttonCode.userInteractionEnabled = YES;
        self.buttonCode.alpha = 1;
        [self.codeTimer invalidate];
        self.codeTimer = nil;
        self.time = 60;
    }
    self.time-=1;
}

- (IBAction)pressLoginBtn:(UIButton *)sender {
    if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showError:@"phone number is empty"];
        return;
    }
    else if (!(self.phoneTextField.text.length == 11 || self.phoneTextField.text.length == 10)){
        [MBProgressHUD showError:@"error input format"];
    }
    if (self.codeTextField.text.length == 0) {
        [MBProgressHUD showError:@"verification is empty"];
        return;
    }
    [MBProgressHUD showMessage:@"Login..."];
    [HttpService loginWithMobile:self.phoneTextField.text country:self.countryNumber verificationCode:self.codeTextField.text result:^(CommonReturn *commonReturn) {
        
        if (commonReturn.state == 1) {
            if (commonReturn.data) {
                LiveUser* userInfo = [[LiveUser alloc] initWithDic:commonReturn.data];
                [Config saveProfile:userInfo];
                if ([userInfo.first intValue]==1) {
                    ProfileSetupViewController *profileSetupViewController = [[ProfileSetupViewController alloc] init];
                    
                    // hides all fields except nick name and birthday
                    //  default image will be set on server side
                    [profileSetupViewController setEditMode:NO];
                    
                    // NOTE_10.01.16: per jason, changed back to old model
                    //  (always use update profile request; set isEditMode = YES)
//                    [profileSetupViewController setEditMode:YES];
                    
                    profileSetupViewController.first = [userInfo.first intValue];
                    [self.navigationController pushViewController:profileSetupViewController animated:YES];
                }else{
                    [appDelegate showTabBarController];
                }
                [MBProgressHUD hideHUD];
            }
        }
    }];
}

//键盘隐藏
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.codeTimer invalidate];
    self.codeTimer = nil;
}

- (IBAction)choseCountryNumber:(UIButton *)sender {
    
// note_09.27.16: allow select country code for sandbox_mode only
#if run_sandbox_mode
    CountryViewController *countryViewController = [[CountryViewController alloc] init];
    [self.navigationController pushViewController:countryViewController animated:YES];
#endif
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // enable / disable 'send code' button
    int lengthPhone = (int)self.phoneTextField.text.length + (int)string.length;
    if (textField == self.phoneTextField) {
        if ([string isEqualToString:@""]) {
            lengthPhone--;
        }
        if (lengthPhone > 9) {
            [self.buttonCode setBackgroundImage:[UIImage imageNamed:@"smallBlueBtn"] forState:UIControlStateNormal];
            self.buttonCode.userInteractionEnabled = YES;
        }else {
            [self.buttonCode setBackgroundImage:[UIImage imageNamed:@"sendCode"] forState:UIControlStateNormal];
            self.buttonCode.userInteractionEnabled = NO;
        }
    }
    
    // enable / disable 'next' button
    int length = (int)self.codeTextField.text.length + (int)string.length;
    if ([string isEqualToString:@""]) {
        length--;
    }
    if (length > 3 && lengthPhone > 9) {
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"loginBlue"] forState:UIControlStateNormal];
        self.loginButton.userInteractionEnabled = YES;
    }else {
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"loginButton"] forState:UIControlStateNormal];
        self.loginButton.userInteractionEnabled = NO;
    }

    // if current phone text field length is >= 10
    uint len = (uint)textField.text.length;
    if (textField == self.phoneTextField && len >= 10)
    {
        // if last added strin was empty, it was a delete,
        //  return YES, (peform delete)
        if ([ObjectTypeValidator nsstringIsNilOrEmpty:string])
        {
            return YES;
        }
        
        // if last added string was not a delete,
        //  return NO (don't add)
        return NO;
    }
    return YES;
}

@end
