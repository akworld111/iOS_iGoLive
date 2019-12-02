
#import "AppDelegate.h"
#import "Config.h"

#import <AdSupport/AdSupport.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

#import "NewLoginController.h"

#import "PersonalCenterController.h"
#import "NewEmergingViewController.h"
#import "FollowingViewController.h"
#import "OnStageViewController.h"
#import "EmergingViewController.h"

#import "HomeViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate {
    BOOL versionUpdateIsShown;
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - native delegates
////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UINavigationBar appearance].barTintColor = navigationBGColor;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    
    [application cancelAllLocalNotifications];
    
    
    self.loginType = -1;
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    //[FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    [self.window makeKeyAndVisible];

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    
    [Fabric with:@[[Twitter class]]];
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [GIDSignIn sharedInstance].delegate = self;
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
#if validate_app_version
    versionUpdateIsShown = NO;
    [self performRequestCheckAppVersion];
#endif
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [FBSDKAppEvents activateApp];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 'home' view / tab bar helpers and delegates (not working)
////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showTabBarController {
    
    /* init and set tab bar controller properties if needed
     initializes child view controller and tab bar items accordingly */
    [self initTabBarControllerIfNeeded];
    
    /* set the tab bar controller as the root view controller */
    self.window.rootViewController = self.mainTabBarController;
    self.mainTabBarController.selectedIndex = 0;
}
- (void)initTabBarControllerIfNeeded
{
    if (self.mainTabBarController)
    {
        XLM_info(@"mainTabBarController already exists; returning w/o initializing any new VCs or re-setting tab bar items");
        return;
    }
    XLM_info(@"mainTabBarController is nil; proceeding to initialize with required child VCs and tab bar items");
    
    self.mainTabBarController = [[IGOTabBarController alloc] init];
    //[(UITabBarController*)self.mainTabBarController setDelegate:self]; // 09.16.16: trying to get animation when switching tabs (not working; tried in IGOTabBarController as well)
    
    
    
    /* create tab bar view controllers (1 for each tab bar bottom) */
    NewEmergingViewController *vc0 = [[NewEmergingViewController alloc] init];
    FollowingViewController *vc1 = [[FollowingViewController alloc] init];
    
    UIViewController *vc2 = [[UIViewController alloc] init]; // fake vc for center placeholder button
    
    EmergingViewController *vc3 = [[EmergingViewController alloc] init];
    PersonalCenterController *vc4 = [[PersonalCenterController alloc] init];
    
    /* create nav controller wrapper for each real vc */
    UINavigationController *nav0 = [self getTabBarNavControllerFor:vc0
                                                          norImage:[UIImage imageNamed:f_imgTabBarHomeNor]
                                                          selImage:[UIImage imageNamed:f_imgTabBarHomeSel]
                                                             title:nil];
    UINavigationController *nav1 = [self getTabBarNavControllerFor:vc1
                                                          norImage:[UIImage imageNamed:f_imgTabBarFollowNor]
                                                          selImage:[UIImage imageNamed:f_imgTabBarFollowSel]
                                                             title:str_nav_title_follow];
    
    vc2.title = @""; // just set title for fake vc
    
    UINavigationController *nav3 = [self getTabBarNavControllerFor:vc3
                                                          norImage:[UIImage imageNamed:f_imgTabBarEmergNor]
                                                          selImage:[UIImage imageNamed:f_imgTabBarEmergSel]
                                                             title:str_nav_title_explore];
    UINavigationController *nav4 = [self getTabBarNavControllerFor:vc4
                                                          norImage:[UIImage imageNamed:f_imgTabBarProfNor]
                                                          selImage:[UIImage imageNamed:f_imgTabBarProfSel]
                                                             title:nil];
    
    /* set the VCs to the tab bar controller */
    [self.mainTabBarController setViewControllers:@[nav0, nav1, vc2, nav3, nav4]];
}
- (UINavigationController*)getTabBarNavControllerFor:(UIViewController *)vc norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title
{
    /* REQUIRED to get the images to display */
    norImage = [norImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    /* set tab bar image for this vc */
    vc.tabBarItem.image = norImage;
    vc.tabBarItem.selectedImage = selImage;
    
    /* set tab bar item image offset for display without a title */
    [ViewModifierHelpers setTabBarItemTitleNilWithImgOffset:vc.tabBarItem];
    
    
        /* NOTE: '.title' (for vc, tabBarItem, and navigationItem)
             vc.title = @"title";                // by default sets 'vc.tabBarItem.title' & 'vc.navigationItem.title'
             vc.tabBarItem.title = @"title";     // does NOT modify 'vc.title'
             vc.navigationItem.title = @"title"; // does NOT modify 'vc.title'
         */
    
    /* set nav bar title for this vc */
    vc.navigationItem.title = title;    /* does NOT modify 'vc.title' */
    
        /* note_09.16.16: 
            trying to set attributed title string here (not working at all) */
        //if (title)
        //{
        //    NSMutableDictionary *norDict = @{}.mutableCopy;
        //    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:20];
        //    norDict[NSForegroundColorAttributeName] = [UIColor grayColor];
        //    NSAttributedString *atrStrTitle = [[NSAttributedString alloc] initWithString:title attributes:norDict];
        //    vc.navigationItem.title = [NSString stringWithString:atrStrTitle.string];    /* does NOT modify 'vc.title' */
        //}
    
    /* add and return navigation controller */
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    return nav;
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - priv - app version validation
////////////////////////////////////////////////////////////////////////////////////////////////
- (void)performRequestCheckAppVersion
{
    [HttpService getOldestAppVersionSupportForDevice:@"ios" withCallback:^(CommonReturn *cr) {
        if (cr.state == 1) {
            id obj = cr.data[@"min_ios_ver"];
            NSString *minVersion =[ObjectTypeValidator nsstringFromObject:obj];
            if (minVersion)
            {
                // present blocker view overlay (update required)
                if([MiscUtilities isDepricatedAppVersion:minVersion.floatValue])
                {
                    [self presentAlertAppUpdateRequired];
                }
            }
        }
    }];
}
- (void)presentAlertAppUpdateRequired
{
    if (versionUpdateIsShown)
        return;
    
    versionUpdateIsShown = YES;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:str_alert_title_version_update
                          message:str_alert_msg_version_update
                          delegate:self
                          cancelButtonTitle:str_alert_btn_version_update
                          otherButtonTitles:nil];
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) // button 0 clicked
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str_appstore_link]];
        versionUpdateIsShown = NO;
    }
    else if (buttonIndex == 1) // button 1 clicked
    {
        
    }
    else if (buttonIndex == 2) // button 2 clicked
    {
        
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - third party login adapters / helpers / delegates
////////////////////////////////////////////////////////////////////////////////////////////////
/* NOTE: if implemented, this has priority execution over 'application:openURL:sourceApplication:annotation:' */
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options
{
    switch(self.loginType)
    {
        case -1:
            XLM_error(@"self.loginType == -1; it was never set : ( \n returning NO");
            return NO;
        case loginFacebook:
            return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        case loginGoogle:
            return [[GIDSignIn sharedInstance] handleURL:url
                                       sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                              annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
            
        default:
            XLM_error(@"unknown self.loginType == %ui; not sure if what was set : O \n returning NO", self.loginType);
            return NO;
    }
}

/* NOTE: if implemented, 'application:openURL:options:' has priority execution of this function */
/**
    - (BOOL)application:(UIApplication *)application
                openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication
             annotation:(id) annotation
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
 */

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    //NSString *userId = user.userID;                  // For client-side use only!
    //NSString *idToken = user.authentication.idToken; // Safe to send to the server
    //NSString *fullName = user.profile.name;
    //NSString *givenName = user.profile.givenName;
    //NSString *familyName = user.profile.familyName;
    //NSString *email = user.profile.email;
    // ...
}
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


@end




