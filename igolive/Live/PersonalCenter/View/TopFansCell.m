//
//  TopFansCell.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/12.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "TopFansCell.h"

@implementation TopFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)pressFollowButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(choseButton:)]) {
//        sender.tag = self.tag;
        [_delegate choseButton:sender];
    }
}

- (void)layoutSubviews{
    [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followButton setTitle:@"Following" forState:UIControlStateSelected];
    self.headImgView.layer.cornerRadius = 20;
    self.headImgView.layer.masksToBounds = YES;
    
}

- (void)loadData:(CoinRecordModel *)model {
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    self.nickNameLabel.text = model.userNickname;
    self.contributeLabel.text = model.total;
    self.levelLabel.text = model.level;
    self.genderImgView.image = [UIImage imageNamed:[Common getGenderImageNameWithType:model.gender]];
    self.levelColorImgView.image = [UIImage imageNamed:[Common getEllipseImageNameWithLevle:model.level]];
    if (model.isattention == 0) {
        self.followButton.selected = NO;
    }else {
        self.followButton.selected = YES;
    }
}

@end
