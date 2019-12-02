//
//  HomeViewController.m
//  iphoneLive
//
//  Created by christlee on 16/8/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "HomeViewController.h"

#import "FollowingViewController.h"
#import "OnStageViewController.h"
#import "EmergingViewController.h"
#import "NewEmergingViewController.h"
#import "SearchViewController.h"
#import "FilterViewController.h"

#import "ViewModifierHelpers.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FollowingViewController *followingViewController = [[FollowingViewController alloc] init];
    OnStageViewController *onStageViewContoller = [[OnStageViewController alloc] init];
    EmergingViewController *emergingViewController = [[EmergingViewController alloc] init];
//    NewEmergingViewController *newEmergingViewController = [[NewEmergingViewController alloc] init];
    
    NSArray *viewControllers = @[followingViewController, onStageViewContoller, emergingViewController];
//    NSArray *viewControllers = @[followingViewController, onStageViewContoller, newEmergingViewController];
    self.viewControllers = viewControllers;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.backgroundColor = UIColorFromHexAlpha(col_nav_bar_top_green, 1.0f);
    //[ViewModifierHelpers addGradientColorFadedSubLayerToNavBarView:navBar hexColorStart:col_verify_head_lt_green hexColorEnd:col_verify_head_drk_green];
    
#if !run_release_mode // note_09.27.16: this entire vc (HomeViewController) is not in use anymore i don't think)
    //Search Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = searchItem;
    
    //Filter Button
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButtonClick:)];
    self.navigationItem.rightBarButtonItem = filterItem;
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Event
- (IBAction)onSearchButtonClick:(id)sender {
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    
    CATransition* transition = [CATransition animation];
    transition.duration = .45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
//    [self.navigationController pushViewController:vc animated:NO];
    [self presentViewController:searchViewController animated:YES completion:nil];
}
- (IBAction)onFilterButtonClick:(id)sender {
    FilterViewController *vc = [[FilterViewController alloc] init];
//    CGFloat barHeight = [ViewModifierHelpers getNavigatoinBarHeaderFrame:self.navigationController.navigationBar].size.height;
//    
//
//    
//    // set frame of home view (fix bottom?)
//    [vc.view setFrame:self.view.bounds];
    
    // subtract navbar height (fix top?)
//    CGRect frame = vc.view.frame;
//    frame.origin.y = barHeight;
//    frame.size.height = frame.size.height - barHeight;
//    vc.view.frame = frame;
    
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
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
