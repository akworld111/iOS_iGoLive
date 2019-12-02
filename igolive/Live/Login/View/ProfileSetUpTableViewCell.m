//
//  ProfileSetUpTableViewCell.m
//  iphoneLive
//
//  Created by sdd on 16/8/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "ProfileSetUpTableViewCell.h"

@implementation ProfileSetUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _constant.constant = 0.5;
    [self.contentView layoutIfNeeded];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
