
//
//  Created by joeyshen 8/9/16
//  Copyright (c) 2016 igo.live.  All rights reserved.
//
#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface NewLoginController : UIViewController <FBSDKLoginButtonDelegate>

typedef NS_ENUM(uint, LoginType)
{
    loginFacebook,
    loginGoogle
};

@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnMobile;
@property (weak, nonatomic) IBOutlet UISwitch *swtTerms;

@property (weak, nonatomic) IBOutlet UIView *vLogin;
@property (weak, nonatomic) IBOutlet UIView *vFacebookMobile;
@property (weak, nonatomic) IBOutlet UIView *vMobile;



@end


