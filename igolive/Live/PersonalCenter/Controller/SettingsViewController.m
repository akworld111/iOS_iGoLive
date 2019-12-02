//
//  SettingsViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/11.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import <MessageUI/MessageUI.h>
#import "PersonalFollowingViewController.h"
#import "AboutUsViewController.h"

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) NSArray *array;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Settings";
    self.array = @[@"Notifications", @"Feedback", @"Block List", @"About Us", @"Log Out"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)sendMessage {
    NSURL *url = [NSURL URLWithString:@"mailto://10010@qq.com"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingsCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.label.text = self.array[indexPath.row];
    cell.redSwitch.onTintColor = [UIColor colorWithRed:48/255.0 green:35/225.0 blue:174/255.0 alpha:1];
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row != 0) {
        cell.redSwitch.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self sendMessage];
    }
    if (indexPath.row == 4) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    if(indexPath.row == 2) {
        PersonalFollowingViewController *personalFollowingViewController = [[PersonalFollowingViewController alloc]init];
        personalFollowingViewController.type = 2;
        [self.navigationController pushViewController:personalFollowingViewController animated:YES];
    }
    if (indexPath.row == 3) {
        AboutUsViewController *vc = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [Config clearProfile];

        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"NewLogin" bundle:[NSBundle mainBundle]];
        UINavigationController *loginNavController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"NewLogin"];
        appDelegate.window.rootViewController = loginNavController;
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end