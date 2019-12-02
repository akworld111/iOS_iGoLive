//
//  ProfileSetUpTableViewCell.h
//  iphoneLive
//
//  Created by sdd on 16/8/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSetUpTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *contentTextFiled;
@property (strong, nonatomic) IBOutlet UILabel *lineLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constant;

@end
