//
//  CountryViewController.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/17.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "CountryViewController.h"
#import "VerificationViewController.h"

static NSString * const cellIdentifier = @"cellIdentifier";

@interface CountryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *countryArray;
@property (strong, nonatomic) NSArray *countryNumberArray;

@end

@implementation CountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Select Country";
    self.countryArray = @[@"United States", @"China"];
    self.countryNumberArray= @[@"1",@"86"];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.countryArray[indexPath.row] stringByAppendingFormat:@" / +%@",self.countryNumberArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VerificationViewController *verificationViewController = self.navigationController.viewControllers[1];
    verificationViewController.countryNumber = self.countryNumberArray[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
