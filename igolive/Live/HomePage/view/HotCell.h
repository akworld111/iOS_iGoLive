//
//  HotCell.h
//  iphoneLive
//
//  Created by christlee on 16/8/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *tagLabel;
@property (nonatomic, weak) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;
@property (weak, nonatomic) IBOutlet UIImageView *levelColorImgView;
@property (strong, nonatomic) UIButton *watchButton;


- (void)loadData:(AttentionLiveModel *)model;

@end
