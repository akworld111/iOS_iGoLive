//
//  TopFansCell.h
//  iphoneLive
//
//  Created by 王文贺 on 16/8/12.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopFansDelegate <NSObject>

- (void) choseButton:(UIButton *)sender;

@end

@interface TopFansCell : UITableViewCell
@property (strong, nonatomic) id <TopFansDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contributeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelColorImgView;
@property (weak, nonatomic) IBOutlet UILabel *contributDieLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImg;

- (void)loadData:(CoinRecordModel *)model;

@end
