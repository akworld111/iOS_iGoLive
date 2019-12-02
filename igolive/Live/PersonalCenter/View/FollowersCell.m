//
//  FollowersCell.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/14.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "FollowersCell.h"

@implementation FollowersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)choseFollowingBtn:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(choseFollowersButton:)]){
//        sender.tag = self.tag;
        [_delegate choseFollowersButton:sender];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //[self.followingBtn setTitle:@"Following" forState:UIControlStateNormal];
    [self.followingBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
    [self.followingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.followingBtn setBackgroundImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];

    
    [self.followingBtn setTitleColor:COLOR(114, 209, 75, 1.0) forState:UIControlStateSelected];
    [self.followingBtn setTitle:@"Follow" forState:UIControlStateSelected];
    [self.followingBtn setBackgroundImage:[UIImage imageNamed:@"rectangleCopy"] forState:UIControlStateSelected];
    
    _height.constant = 0.5;
    
    [self.contentView layoutIfNeeded];
    
}
@end
