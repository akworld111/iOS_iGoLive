//
//  Created by joeyshen 8/9/16
//  Copyright (c) 2016 igo.live.  All rights reserved.
//

#import "LiveMobileLoginViewController.h"


#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "LiveUser.h"
#import <AFNetworking/AFNetworking.h>
#import <UMMobClick/MobClick.h>

@interface LiveMobileLoginViewController ()
{
    UITextField *phoneT;
    UITextField *messageT;
    NSTimer *messsageTimer;
    UILabel *label;
}

@end

@implementation LiveMobileLoginViewController

int messageI = 60;//SMS countdown 60 s

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [MobClick beginLogPageView:@"liveMobileloginViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [messsageTimer invalidate];
    messsageTimer = nil;
    [MobClick endLogPageView:@"liveMobileloginViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Verification";
  
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    
    //Setting up telephone input
    phoneT = [[UITextField alloc]initWithFrame:CGRectMake(40,120, _window_width-80,50)];
    phoneT.backgroundColor = [UIColor whiteColor];
    phoneT.placeholder = @"Phone Number";
    phoneT.font = FNOT;
    phoneT.clearButtonMode=UITextFieldViewModeWhileEditing;
    phoneT.keyboardType = UIKeyboardTypeNumberPad;
    phoneT.adjustsFontSizeToFitWidth = YES;
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, phoneT.frame.size.height)];
    phoneT.leftViewMode = UITextFieldViewModeAlways;
    phoneT.leftView = leftView;
    
    //Set the text input
    messageT = [[UITextField alloc]initWithFrame:CGRectMake(40,190, _window_width-80,50)];
    messageT.backgroundColor = [UIColor whiteColor];
    messageT.placeholder = @"Code";
    messageT.font = FNOT;
    messageT.clearButtonMode=UITextFieldViewModeWhileEditing;
    messageT.keyboardType = UIKeyboardTypeNumberPad;
    messageT.adjustsFontSizeToFitWidth = YES;
    UIView* leftMessagetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, messageT.frame.size.height)];
    messageT.leftViewMode = UITextFieldViewModeAlways;
    messageT.leftView = leftMessagetView;
 
    [self.view addSubview:phoneT];
    [self.view addSubview:messageT];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100,30)];
    
    label.font = [UIFont systemFontOfSize:15];
    
    label.enabled = YES;
    
    
    label.userInteractionEnabled = YES;
    
    
    label.textColor = [UIColor whiteColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor colorWithRed:203/255.0 green:12/225.0 blue:37/255.0 alpha:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(verificationCode)];
    
    tap.numberOfTapsRequired = 1;
    
    tap.numberOfTouchesRequired = 1;
    
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 15;
    [label addGestureRecognizer:tap];
    
    
    label.text = @"Send Code";
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, phoneT.frame.size.height)];
    [view addSubview:label];
    phoneT.rightViewMode = UITextFieldViewModeAlways;
    phoneT.rightView = view;
    
    
    //Set the confirm button
    UIButton *enterBTN = [UIButton buttonWithType:UIButtonTypeSystem];
    [enterBTN setTitle:@"Login" forState:UIControlStateNormal];
    [enterBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enterBTN setBackgroundImage:[UIImage imageNamed:@"Rectangle_106"] forState:UIControlStateNormal];
    [enterBTN addTarget:self action:@selector(doEnter) forControlEvents:UIControlEventTouchUpInside];
    enterBTN.frame = CGRectMake(40,_window_height*0.5, _window_width-80,50);
    enterBTN.layer.masksToBounds = YES;
    enterBTN.layer.cornerRadius = 5;
    [self.view addSubview:enterBTN];
    
    
}

//Countdown to get verification code
- (void)countDown {
    label.alpha = 0.6;
    label.text = [NSString stringWithFormat:@"%ds",messageI];
    label.userInteractionEnabled = NO;
    
    if (messageI<=0) {
    
        label.text = @"send code";
        label.userInteractionEnabled = YES;
        label.alpha = 1;
        [messsageTimer invalidate];
        messsageTimer = nil;
        messageI = 60;
    }
    messageI-=1;
    
}

//Get verification code
- (void)verificationCode {
    [self.view endEditing:YES];
    messageI = 60;
    if (phoneT.text.length!=11){
        [MBProgressHUD showError:@"error format"];
    }
    else{
//        [MBProgressHUD showMessage:@"Please wait"];
//        [HttpService getSMSCodeWithMobile:phoneT.text result:^(CommonReturn *commonReturn) {
//            [MBProgressHUD hideHUD];
//            if (commonReturn.state == 1) {
//                [MBProgressHUD showSuccess:@"sent success"];
//                if (messsageTimer == nil) {
//                    messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
//                }
//            }else{
//                [MBProgressHUD showError:commonReturn.msg];
//            }
//        }];
    }
}
//The keyboard of the hidden
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

//login
- (void)doEnter {
    
    if (phoneT.text.length == 0) {
        [MBProgressHUD showError:@"phone number is empty"];
        return;
    }
    else if (phoneT.text.length!=11){
        [MBProgressHUD showError:@"error input format"];
    }
    if (messageT.text.length == 0) {
        [MBProgressHUD showError:@"verification is empty"];
        return;
    }
    [MBProgressHUD showMessage:@"Login..."];
//    [HttpService loginWithMobile:phoneT.text verificationCode:messageT.text result:^(CommonReturn *commonReturn) {
//        if (commonReturn.state ==  1) {
//            if(commonReturn.data[@"info"])
//            {
//                LiveUser *userInfo = [[LiveUser alloc] initWithDic:commonReturn.data[@"info"]];
//                
//                [Config saveProfile:userInfo];
//                [MobClick profileSignInWithPUID:[Config getOwnID]];
//                
//                
//                NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
//                //[APService setTags:[NSSet setWithObjects:@"tag4",@"tag5",@"tag6",nil] alias:aliasStr callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
//                
//                [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
//                
//
//                NSString *passWord = [@"wl" stringByAppendingPathComponent:[Config getOwnID]];
//                EMError *error = [[EMClient sharedClient] registerWithUsername:[Config getOwnID] password:passWord];
//                if (error == nil) {
//                    NSLog(@"  ****************registration success**************%@",[Config getOwnID]);
//                }
//                self.navigationController.hidesBottomBarWhenPushed = YES;
//                
//                int index=[[self.navigationController viewControllers]indexOfObject:self];
//                
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
//                
//                self.navigationController.hidesBottomBarWhenPushed = YES;
//                
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"loginfirstPage" object:nil];
//                [MBProgressHUD hideHUD];
//                
//            }else{
//                [MBProgressHUD showMessage:@"In order to get the data"];
//            }
//            NSLog(@"connect again");
//        } else {
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:commonReturn.msg];
//        }
//    }];
   
}

@end
