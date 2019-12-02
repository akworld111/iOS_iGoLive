//
//  ShowGiftItem.h
//  igolive
//
//  Created by 高翔 on 16/8/30.
//  Copyright © 2016年 iGoLive LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleLabel.h"

@protocol ShowGiftItemDelegate <NSObject>
- (void)giftWillDeleteWithShowIndex:(int)showIndex;
@end

@interface ShowGiftItem : UIView
@property (assign, nonatomic) id <ShowGiftItemDelegate> delegate;
@property (strong, nonatomic) SendGiftModel *model;
@property (assign, nonatomic) int showIndex;
@property (strong, nonatomic) NSTimer *deleteTime;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *depictLab;
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftImageTrailing;
@property (weak, nonatomic) IBOutlet UIView *vContainer;
@property (strong, nonatomic) ScaleLabel *multipleLabel;

- (void)animation;
@end
