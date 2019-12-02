//
//  ShowGiftItem.m
//  igolive
//
//  Created by 高翔 on 16/8/30.
//  Copyright © 2016年 iGoLive LLC. All rights reserved.
//

#import "ShowGiftItem.h"

@implementation ShowGiftItem

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ShowGiftItem" owner:self options:nil] firstObject];
    if (self) {
        self.multipleLabel = [[ScaleLabel alloc] initWithFrame:CGRectMake(170, 33, 60, 20)];
        self.multipleLabel.startScale = 2;
        self.multipleLabel.endScale = 1.5;
        self.multipleLabel.backedLabelColor = [UIColor purpleColor];
        self.multipleLabel.colorLabelColor = [UIColor purpleColor];
        [self addSubview:self.multipleLabel];
        self.layer.masksToBounds = NO;
    }
    return self;
}

- (void)animation {
    self.frame = CGRectMake(-200, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.giftImageTrailing.constant = 0;
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
           self.deleteTime =  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(deleteSelf) userInfo:nil repeats:NO];
        }];
    }];
}

- (void)deleteSelf {
    self.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(giftWillDeleteWithShowIndex:)]) {
        [self.delegate giftWillDeleteWithShowIndex:self.showIndex];
    }
    [self removeFromSuperview];
}
@end
