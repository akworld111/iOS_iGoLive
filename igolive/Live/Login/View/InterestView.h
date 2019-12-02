//
//  InterestView.h
//  igolive
//
//  Created by 宋丹丹 on 16/8/29.
//  Copyright © 2016年 iGoLive LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterestViewDelegate <NSObject>

-(void)sendArray:(NSMutableArray*)array;

@end

@interface InterestView : UIView

-(id)initWithFrame:(CGRect)frame withArray:(NSArray*)interestArray withSelectInterestArray:(NSArray*)selectInterestArray;

@property (nonatomic , weak) id<InterestViewDelegate> delegate;
@end
