
#import "XZMTabBarViewController.h"
#import "XZMTabbarExtension.h"
#import "HomeViewController.h"
#import "PersonalCenterController.h"
#import "NewEmergingViewController.h"
#import "FollowingViewController.h"
#import "OnStageViewController.h"
#import "EmergingViewController.h"

@interface XZMTabBarViewController ()

@end

@implementation XZMTabBarViewController

+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    /** 设置默认状态 (felix: 'default status') */
    NSMutableDictionary *norDict = @{}.mutableCopy;
    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    norDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    [tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
    
    /** 设置选中状态 (felix: 'select status') */
//    NSMutableDictionary *selDict = @{}.mutableCopy;
//    selDict[NSFontAttributeName] = norDict[NSFontAttributeName];
//    selDict[NSForegroundColorAttributeName] = [UIColor blackColor];
//    [tabBarItem setTitleTextAttributes:selDict forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NewEmergingViewController *newEmergingViewController = [[NewEmergingViewController alloc] init];
    FollowingViewController *followingVC = [[FollowingViewController alloc] init];
    EmergingViewController *EmergingVC = [[EmergingViewController alloc] init];
    PersonalCenterController *personalCenterController = [[PersonalCenterController alloc] init];
    
    //add childViewController
    [self setUpChildControllerWith:newEmergingViewController norImage:[UIImage imageNamed:@"Home_Regular"] selImage:[UIImage imageNamed:@"Home"] title:@""];
    [self setUpChildControllerWith:followingVC norImage:[UIImage imageNamed:@"following_regular"] selImage:[UIImage imageNamed:@"following_pressed"] title:@""];
    [self setUpChildControllerWith:EmergingVC norImage:[UIImage imageNamed:@"explore_regular"] selImage:[UIImage imageNamed:@"discover_pressed"] title:@""];
    [self setUpChildControllerWith:personalCenterController norImage:[UIImage imageNamed:@"Profile_regular"] selImage:[UIImage imageNamed:@"Profile"] title:@""];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -3, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"tabbar"]];
    [imageView setContentMode:UIViewContentModeCenter];
    [self.tabBar insertSubview:imageView atIndex:0];

    [[UITabBar appearance] setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    [[UITabBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor clearColor]]];

    UITabBar.appearance.tintColor = [UIColor whiteColor];
    
    //config center button
    [self.tabBar setUpTabBarCenterButton:^(UIButton *centerButton) {
        [centerButton setBackgroundImage:[UIImage imageNamed:@"Livestream_button"] forState:UIControlStateNormal];
        
        [centerButton setBackgroundImage:[UIImage imageNamed:@"Livestream_button"] forState:UIControlStateSelected];
        
        [centerButton addTarget:self action:@selector(chickCenterButton) forControlEvents:UIControlEventTouchUpInside];
    }];

}

-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)chickCenterButton {
    [MBProgressHUD showMessage:@"Loading..."];
    [HttpService getLevelLimitWithResult:^(CommonReturn *commonReturn) {
        if (commonReturn.state == 1) {
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"LiveStream" bundle:[NSBundle mainBundle]];
            UINavigationController *loginNavController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"LiveStreamNavigation"];
            [self presentViewController:loginNavController animated:YES completion:nil];
        }
    }];
}

- (void)setUpChildControllerWith:(UIViewController *)childVc norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    if ([childVc isKindOfClass:[PersonalCenterController class]]) {
        UINavigationBar *navBar = nav.navigationBar;
        [ViewModifierHelpers addGradientColorFadedSubLayerToNavBarView:navBar hexColorStart:col_view_bg_drk_purple hexColorEnd:col_view_bg_lt_purple];
        navBar.alpha = 1;

    }
    
//    else if ([childVc isKindOfClass:[HomeViewController class]]){
//        //    UINavigationBar *navBar = self.navigationController.navigationBar;
//        //    [ViewModifierHelpers addGradientColorFadedSubLayerToNavBarView:navBar hexColorStart:col_btnDone_drk_green hexColorEnd:col_btnDone_lt_green];
//
//    }
    childVc.title = title;
    norImage = [norImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.image = norImage;
    childVc.tabBarItem.selectedImage = selImage;
    
    [self addChildViewController:nav];
    
}

@end
