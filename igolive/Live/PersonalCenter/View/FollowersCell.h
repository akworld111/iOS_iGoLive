//
//  FollowersCell.h
//  iphoneLive
//
//  Created by 王文贺 on 16/8/14.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FollowersDelegate <NSObject>

- (void)choseFollowersButton:(UIButton *)sender;
@end

@interface FollowersCell : UITableViewCell
@property (strong, nonatomic)id<FollowersDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *followingBtn;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UIImageView *gender;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height;

@end
