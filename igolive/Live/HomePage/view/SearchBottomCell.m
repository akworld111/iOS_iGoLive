//
//  SearchBottomCell.m
//  iphoneLive
//
//  Created by 王文贺 on 16/8/25.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "SearchBottomCell.h"
@interface SearchBottomCell () {
    NSMutableArray *marr;
}
@end

@implementation SearchBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    marr = [NSMutableArray array];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updataScrollViewWithNumber:(int)number {
    CGFloat imageW = 40;
    CGFloat spacing = 20;
    CGFloat audienceScrollViewH = self.scrollView.frame.size.height;
    for (NSInteger index = 0; index < number; index++) {
        if (marr.count > index) {
            index = marr.count;
            continue;
        }
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(index*(imageW + spacing) + 20, (audienceScrollViewH - imageW)/2, imageW, imageW);
        image.image = [UIImage imageNamed:@"head_light"];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = imageW/2;
        image.userInteractionEnabled = YES;
        image.tag = 200 + index;
        [marr addObject:image];
        [self.scrollView addSubview:image];
    }
    [self.scrollView setContentSize:CGSizeMake(number*(imageW + spacing), 0)];
}

@end
