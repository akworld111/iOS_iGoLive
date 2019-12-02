//
//  SearchViewController.m
//  iphoneLive
//
//  Created by christlee on 16/8/12.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchBottomCell.h"
#import "TopFansCell.h"

@interface SearchViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTextFiled;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* nameArray;

@end
@implementation SearchViewController

static NSString *const searchBottomCellIdentifier = @"SearchBottomCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchBottomCell" bundle:nil] forCellReuseIdentifier:searchBottomCellIdentifier];
    self.searchTextFiled.layer.masksToBounds = YES;
    self.searchTextFiled.layer.cornerRadius = 15;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, self.searchTextFiled.frame.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"searchGreen"];
    [view addSubview:imageView];
    self.searchTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextFiled.leftView = view;
    self.nameArray = @[@"Entertainment", @"Beauty", @"Sports", @"Fashion", @"Technology"];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return self.nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TopFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopFansCell"];
        if (!cell) {
            NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"TopFansCell" owner:nil options:nil];
            cell = [views objectAtIndex:0];
        }
        cell.contentView.backgroundColor = [UIColor colorWithRed:99/255.0 green:55/255.0 blue:186/255.0 alpha:1];
        cell.lineView.hidden = YES;
        cell.starImg.hidden = YES;
        cell.levelLabel.textColor = [UIColor whiteColor];
        cell.contributeLabel.textColor = [UIColor whiteColor];
        cell.nickNameLabel.textColor = [UIColor whiteColor];
        cell.contributDieLabel.textColor = [UIColor whiteColor];
        cell.rankLabel.textColor = [UIColor whiteColor];
        if (indexPath.row == 0) {
            cell.rankImageView.image = [UIImage imageNamed:@"1st_place"];
            cell.rankLabel.hidden = YES;
        }
        if (indexPath.row == 1) {
            cell.rankImageView.image = [UIImage imageNamed:@"2nd_place"];
            cell.rankLabel.hidden = YES;
        }
        if (indexPath.row == 2) {
            cell.rankImageView.image = [UIImage imageNamed:@"3rd_place"];
            cell.rankLabel.hidden = YES;
        }
        if (indexPath.row > 2) {
            cell.rankLabel.text = [NSString stringWithFormat:@"%li",1 +indexPath.row];
            cell.rankImageView.hidden = YES;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    SearchBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:searchBottomCellIdentifier forIndexPath:indexPath];
    [cell updataScrollViewWithNumber:40];
    cell.nameLabel.text = self.nameArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 75;
    }
    return 110;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
- (IBAction)backButton:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
