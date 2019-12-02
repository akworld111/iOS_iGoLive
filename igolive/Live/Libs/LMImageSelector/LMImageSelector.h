//
//  LMImageSelector.h
//  LMImageSelector
//
//  Created by 高翔 on 16/7/1.
//  Copyright © 2016年 高翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ResultBlock)(UIImage *image);

@interface LMImageSelector : NSObject

- (void)showImageSheetWithView:(UIViewController *)viewController type:(int)type result:(ResultBlock)resultBlock;
@end
