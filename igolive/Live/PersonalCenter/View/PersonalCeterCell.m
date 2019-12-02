//
//  PersonalCeterCell.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/10.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "PersonalCeterCell.h"

@implementation PersonalCeterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//#if run_release_mode
//    self.image.hidden = YES;
//    self.imageFansHead.hidden = YES;
//    self.followerImage.hidden = YES;
//#endif
    self.imageFansHead.layer.masksToBounds = YES;
    self.imageFansHead.layer.cornerRadius = 12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
