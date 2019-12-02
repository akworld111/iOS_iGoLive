//
//  NewLoginController.m
//
//  Created by joeyshen 8/9/16
//  Copyright (c) 2016 igo.live.  All rights reserved.
//

#import "NewLoginController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ProfileSetupViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>
#import <Google/SignIn.h>
#import "MBProgressHUD.h"
#import "LookLiveStreamViewController.h"
#import "VerificationViewController.h"
#import "InstagramViewController.h"
#import "SUCache.h"
#import "TermsViewController.h"


@interface NewLoginController ()
@property (weak, nonatomic) IBOutlet UIView *vTerms;

@property (weak, nonatomic) IBOutlet UIView *moviePlayerView;
@property(nonatomic,retain)MPMoviePlayerController *moviePlayer;
@end    

@implementation NewLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackgroundMovie];

    SUCacheItem *item = [SUCache itemForSlot:0];
    [self labelDisplayWithProfile:item.profile];

    if ([Config getOwnID] != nil && [Config getOwnToken] != nil) {
        [appDelegate showTabBarController];
    }
    
    
// note:09.30.16: show only sms login for release_mode and stage_mode
#if !run_sandbox_mode
    self.vMobile.hidden = NO;
    self.vFacebookMobile.hidden = YES;
    self.vLogin.hidden = YES;
#endif
}
- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updateContent:)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_accessTokenChanged:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.swtTerms setOn:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tabBar hideTabBar:YES];
    self.navigationController.navigationBarHidden = YES;
    [self playBackgroundMovie];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopBackgroundMovie];
}

////////////////////////////////////////////////////
#pragma mark - priv - background movie helpers
////////////////////////////////////////////////////
- (void)initBackgroundMovie
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"welcome_flash_bg" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [self.moviePlayer.view setFrame:self.view.bounds];
    self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.moviePlayer.view.userInteractionEnabled = NO;
    [self.moviePlayerView addSubview:self.moviePlayer.view];
}
- (void)playBackgroundMovie
{
    [self.moviePlayer play];
}
- (void)stopBackgroundMovie
{
    [self.moviePlayer stop];
}

////////////////////////////////////////////////////
#pragma mark - priv - xib binding
////////////////////////////////////////////////////
- (IBAction)facebookLogin:(UIButton *)sender {
    if (![self validateTosAccepted]) {
        return;
    }
    
    appDelegate.loginType = loginFacebook;
    NSInteger slot = 0;
    FBSDKAccessToken *token = [SUCache itemForSlot:slot].token;
    if (token) {
        [self autoFacebookLoginWithToken:token];
    } else {
        [self newFacebookLogin];
    }
}
- (IBAction)twitterLogin:(UIButton *)sender {
    if (![self validateTosAccepted]) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    [appDelegate showTabBarController];
    
    [self stopBackgroundMovie];
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError*error) {
        hud.mode = MBProgressHUDModeText;
        
        if(session) {
            hud.labelText = @"Twitter login success";
            sleep(1);
            NSLog(@"signed in as %@", [session userName]);

            [self stopBackgroundMovie];
            
            [appDelegate showTabBarController];
        } else{
            hud.labelText = @"Twitter login failed";
            NSLog(@"error: %@", [error localizedDescription]);
            
        }
        
        [hud hide:YES afterDelay:1];
    }];
}
- (IBAction)mobileClick:(UIButton *)sender {
    if (![self validateTosAccepted]) {
        return;
    }
    
    [self stopBackgroundMovie];
    VerificationViewController* verifcationController = [[VerificationViewController alloc] init];
    [self.navigationController pushViewController:verifcationController animated:YES];
}
- (IBAction)googleLogin:(UIButton *)sender {
    if (![self validateTosAccepted]) {
        return;
    }
    
    appDelegate.loginType = loginGoogle;
}
- (IBAction)instagramLogin:(UIButton *)sender {
    NSLog(@"%s",__func__);
    
    if (![self validateTosAccepted]) {
        return;
    }
    
    InstagramViewController * instagramViewController = [[InstagramViewController alloc] init];
    [self.navigationController pushViewController:instagramViewController animated:YES];
}
- (IBAction)agreementClick:(UIButton *)sender {
    TermsViewController *termsViewController = [[TermsViewController alloc] init];
    [self.navigationController pushViewController:termsViewController animated:YES];
}
- (BOOL)validateTosAccepted
{
    
    if (![self.swtTerms isOn])
    {
        [AlertViewHelpers presentAlertWithTitle:@"Terms & Conditions" message:@"Please accept the Terms & Conditions to proceed" delegate:nil];
        return NO;
    }
    
    return YES;
    
}
////////////////////////////////////////////////////
#pragma mark - priv - facebook helpers / delegates
////////////////////////////////////////////////////
- (void)newFacebookLogin {
    
    /*
        displays facebook native button for login
     */
    //[[FBSDKLoginManager new] logOut];
    //FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    //loginButton.center = self.view.center;
    //loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    //[loginButton setDelegate:self];
    //[self.view addSubview:loginButton];
    
    
    /*
        performs login w/o displaying facebook native button first
     */
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                 XLM_enter(@"\nloginResult.grantedPermissions: %@", result.grantedPermissions);
                                 if (error) {
                                     XLM_error(@"loginResult error: %@", error.description);
                                 } else if (result.isCancelled) {
                                     XLM_info(@"loginResult: canceled");
                                 } else {
                                     XLM_info(@"\nloginResult: login SUCCESS! \ndisplaying main view");
                                     
                                     [self stopBackgroundMovie];
                                     [appDelegate showTabBarController];
                                 }
                            }];
}
- (void)labelDisplayWithProfile:(FBSDKProfile *)profile{
    NSInteger slot = 0;
    if (profile) {
        SUCacheItem *cacheItem = [SUCache itemForSlot:slot];
        cacheItem.profile = profile;
        [SUCache saveItem:cacheItem slot:slot];
        NSLog(@"name = %@, userID = %@", cacheItem.profile.name, cacheItem.profile.userID);
    }
}

/*  
    delegates for utilizing native FBSDKLoginButton display 
 */
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    XLM_enter(@"\nloginResult.grantedPermissions: %@", result.grantedPermissions);
    if (error) {
        XLM_error(@"loginResult error: %@", error.description);
    } else if (result.isCancelled) {
        XLM_info(@"loginResult: canceled");
    } else {
        XLM_info(@"\nloginResult: login SUCCESS! \ndisplaying main view");
        [appDelegate showTabBarController];
    }
}
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    XL_enter();
}
- (void)autoFacebookLoginWithToken:(FBSDKAccessToken *)token {
    [FBSDKAccessToken setCurrentAccessToken:token];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            XLM_warning(@"\nlogin FAILED with existing token \ncalling newFacebookLogin");
            
            NSInteger slot = 0;
            [SUCache deleteItemInSlot:slot];
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
            
            [self newFacebookLogin];
        } else {
            XLM_info(@"\nlogin SUCCESS with existing token! \ndisplaying main view");
            [appDelegate showTabBarController];
        }
    }];
}
- (void)_updateContent:(NSNotification *)notification {
    FBSDKProfile *profile = notification.userInfo[FBSDKProfileChangeNewKey];
    [self labelDisplayWithProfile:profile];
}

- (void)_accessTokenChanged:(NSNotification *)notification {
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    if (!token) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    } else {
        NSInteger slot = 0;
        SUCacheItem *item = [SUCache itemForSlot:slot] ?: [[SUCacheItem alloc] init];
        if (![item.token isEqualToAccessToken:token]) {
            item.token = token;
            [SUCache saveItem:item slot:slot];
        }
    }
}

@end






