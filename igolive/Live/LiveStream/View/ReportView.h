//
//  ReportView.h
//  hollyWood
//
//  Created by 王文贺 on 16/8/6.
//  Copyright © 2016年 王文贺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupModel.h"

typedef void (^CloseBtnClickBlock)();
typedef void (^ProfileBtnClickBlock)();
typedef void (^FollowSuccess)();
typedef void (^ReportBtnClickBlock)();

typedef void (^FirstFanClickBlock)(NSString *uid);
typedef void (^SecondFanClickBlock)(NSString *uid);
typedef void (^ThirdFanClickBlock)(NSString *uid);

@interface ReportView : UIView <AlertViewHelpersDelegate>
@property (strong, nonatomic) ReportView *reportView;
@property (strong, nonatomic) NSString *targetuid;
@property (strong, nonatomic) NSString *showid;
@property (strong, nonatomic) PopupModel *popupModel;



@property (copy, nonatomic) CloseBtnClickBlock closeBtnClickBlock;
@property (copy, nonatomic) ProfileBtnClickBlock profileBtnClickBlock;
@property (copy, nonatomic) FollowSuccess followSuccess;
@property (copy, nonatomic) ReportBtnClickBlock reportBtnClickBlock;

@property (copy, nonatomic) FirstFanClickBlock firstFanClickBlock;
@property (copy, nonatomic) SecondFanClickBlock secondFanClickBlock;
@property (copy, nonatomic) ThirdFanClickBlock thirdFanClickBlock;

+ (instancetype)reportView;
- (void)updateView;

@end




