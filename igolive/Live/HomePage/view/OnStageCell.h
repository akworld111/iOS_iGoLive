//
//  OnStageCell.h
//  iphoneLive
//
//  Created by 王文贺 on 16/8/7.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnStageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *massgeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelColorImgView;
@property (strong, nonatomic) UIButton *watchButton;

- (void)loadData:(AttentionLiveModel *)model;

@end
