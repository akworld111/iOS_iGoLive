
#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import "IGOTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>
//@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate, UITabBarControllerDelegate>

@property (retain, nonatomic) IGOTabBarController *mainTabBarController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) uint loginType;

- (void)showTabBarController;

@end

