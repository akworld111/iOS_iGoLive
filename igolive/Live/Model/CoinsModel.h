//
//  CoinsModel.h
//  iphoneLive
//
//  Created by christlee on 16/8/12.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoinsModel : NSObject

@property (nonatomic, strong) NSString * androidProduct;
@property (nonatomic, strong) NSString * appleProduct;
@property (nonatomic, strong) NSString * bonus;
@property (nonatomic, strong) NSString * coins;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * usd;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
