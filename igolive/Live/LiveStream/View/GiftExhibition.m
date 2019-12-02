//
//  GiftExhibition.m
//  igolive
//
//  Created by 高翔 on 16/8/30.
//  Copyright © 2016年 iGoLive LLC. All rights reserved.
//
#define MaxShow 2

#import "GiftExhibition.h"
#import "ShowGiftItem.h"
#import "ViewModifierHelpers.h"

@interface GiftExhibition () <ShowGiftItemDelegate> {
    NSMutableArray<SendGiftModel *> *_sendGiftModelArray;
    int nowShow;
    BOOL showColumn[MaxShow];
    int sendCount[MaxShow];
}
@end

@implementation GiftExhibition
- (instancetype)init {
    self = [super init];
    if (self) {
        _sendGiftModelArray = [NSMutableArray array];
        sendCount[0] = 1;
        sendCount[1] = 1;
    }
    return self;
}


- (void)showGiftWithSendGiftModel:(SendGiftModel *)model {
    if (nowShow) {
        BOOL isContinuitySend = NO;
        for (ShowGiftItem *item in self.subviews) {
            if ([item class] == [ShowGiftItem class]) {
                
                /*
                    eg_09.30.16: crash at this point using model.uid
                     fixed by type checking SendGiftModel.uid on initialization (in SendGiftModel.m)
                 */
                if ([item.model.uid isEqualToString:model.uid] && item.model.ct.giftid == model.ct.giftid) {
                    [self continuitySendUpdataWithGiftItem:item];
                    isContinuitySend = YES;
                }
            }
        }
        if (isContinuitySend) {
            return;
        }
    }
    if (nowShow < MaxShow) {
        [self showGiftWithModel:model];
    } else {
        [_sendGiftModelArray addObject:model];
    }
}

- (void)showGiftWithModel:(SendGiftModel *)model {
    nowShow++;
    CGFloat giftItemH = 44;
    ShowGiftItem *giftItem = [[ShowGiftItem alloc] init];
    giftItemH = giftItem.frame.size.height;
    giftItem.delegate = self;
    if (!showColumn[0]) {
        showColumn[0] = YES;
        giftItem.frame = CGRectMake(0, giftItemH * 0, 200, giftItemH);
        giftItem.tag = 0;
    } else {
        showColumn[1] = YES;
        giftItem.frame = CGRectMake(0, giftItemH * 1, 200, giftItemH);
        giftItem.showIndex = 1;
        giftItem.tag = 1;
    }
    [self addSubview:giftItem];
    giftItem.model = model;
    [giftItem.headImage sd_setImageWithURL:[NSURL URLWithString:model.uhead]];
    [giftItem.giftImage sd_setImageWithURL:[NSURL URLWithString:model.ct.gifticon]];
    giftItem.nameLab.text = model.ct.nicename;
    giftItem.depictLab.text = model.ct.giftname;
    giftItem.multipleLabel.text = [NSString stringWithFormat:@"X%d",1];
    
    [ViewModifierHelpers setCornerRadius:23.5f forView:giftItem.vContainer];
    [giftItem animation];
}

- (void)continuitySendUpdataWithGiftItem:(ShowGiftItem *)item {
    item.multipleLabel.text = [NSString stringWithFormat:@"X%d",++sendCount[item.tag]];
    [item.multipleLabel startAnimation];
    item.deleteTime.fireDate = [NSDate dateWithTimeInterval:3 sinceDate:[NSDate date]];
}

- (void)giftWillDeleteWithShowIndex:(int)showIndex {
    showColumn[showIndex] = NO;
    sendCount[showIndex] = 1;
    nowShow--;
    if (_sendGiftModelArray.count) {
        [self showGiftWithModel:[_sendGiftModelArray firstObject]];
        [_sendGiftModelArray removeObjectAtIndex:0];
    }
}
@end
