//
//  IncomeModel.h
//  iphoneLive
//
//  Created by sdd on 16/8/18.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeModel : NSObject

@property (nonatomic, assign) NSInteger canwithdraw;
@property (nonatomic, strong) NSString * stars;
@property (nonatomic, strong) NSString * starsTotal;
@property (nonatomic, strong) NSString * votes;
@property (nonatomic, assign) NSInteger withdraw;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
