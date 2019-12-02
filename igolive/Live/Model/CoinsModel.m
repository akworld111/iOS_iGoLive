//
//  CoinsModel.m
//  iphoneLive
//
//  Created by christlee on 16/8/12.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "CoinsModel.h"

NSString *const kCoinsModelAndroidProduct = @"android_product";
NSString *const kCoinsModelAppleProduct = @"apple_product";
NSString *const kCoinsModelBonus = @"bonus";
NSString *const kCoinsModelCoins = @"coins";
NSString *const kCoinsModelIdField = @"id";
NSString *const kCoinsModelUsd = @"usd";

@interface CoinsModel ()
@end
@implementation CoinsModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kCoinsModelAndroidProduct] isKindOfClass:[NSNull class]]){
        self.androidProduct = dictionary[kCoinsModelAndroidProduct];
    }
    if(![dictionary[kCoinsModelAppleProduct] isKindOfClass:[NSNull class]]){
        self.appleProduct = dictionary[kCoinsModelAppleProduct];
    }
    if(![dictionary[kCoinsModelBonus] isKindOfClass:[NSNull class]]){
        self.bonus = dictionary[kCoinsModelBonus];
    }
    if(![dictionary[kCoinsModelCoins] isKindOfClass:[NSNull class]]){
        self.coins = dictionary[kCoinsModelCoins];
    }
    if(![dictionary[kCoinsModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kCoinsModelIdField];
    }
    if(![dictionary[kCoinsModelUsd] isKindOfClass:[NSNull class]]){
        self.usd = dictionary[kCoinsModelUsd];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.androidProduct != nil){
        dictionary[kCoinsModelAndroidProduct] = self.androidProduct;
    }
    if(self.appleProduct != nil){
        dictionary[kCoinsModelAppleProduct] = self.appleProduct;
    }
    if(self.bonus != nil){
        dictionary[kCoinsModelBonus] = self.bonus;
    }
    if(self.coins != nil){
        dictionary[kCoinsModelCoins] = self.coins;
    }
    if(self.idField != nil){
        dictionary[kCoinsModelIdField] = self.idField;
    }
    if(self.usd != nil){
        dictionary[kCoinsModelUsd] = self.usd;
    }
    return dictionary;
    
}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.androidProduct != nil){
        [aCoder encodeObject:self.androidProduct forKey:kCoinsModelAndroidProduct];
    }
    if(self.appleProduct != nil){
        [aCoder encodeObject:self.appleProduct forKey:kCoinsModelAppleProduct];
    }
    if(self.bonus != nil){
        [aCoder encodeObject:self.bonus forKey:kCoinsModelBonus];
    }
    if(self.coins != nil){
        [aCoder encodeObject:self.coins forKey:kCoinsModelCoins];
    }
    if(self.idField != nil){
        [aCoder encodeObject:self.idField forKey:kCoinsModelIdField];
    }
    if(self.usd != nil){
        [aCoder encodeObject:self.usd forKey:kCoinsModelUsd];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.androidProduct = [aDecoder decodeObjectForKey:kCoinsModelAndroidProduct];
    self.appleProduct = [aDecoder decodeObjectForKey:kCoinsModelAppleProduct];
    self.bonus = [aDecoder decodeObjectForKey:kCoinsModelBonus];
    self.coins = [aDecoder decodeObjectForKey:kCoinsModelCoins];
    self.idField = [aDecoder decodeObjectForKey:kCoinsModelIdField];
    self.usd = [aDecoder decodeObjectForKey:kCoinsModelUsd];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    CoinsModel *copy = [CoinsModel new];
    
    copy.androidProduct = [self.androidProduct copyWithZone:zone];
    copy.appleProduct = [self.appleProduct copyWithZone:zone];
    copy.bonus = [self.bonus copyWithZone:zone];
    copy.coins = [self.coins copyWithZone:zone];
    copy.idField = [self.idField copyWithZone:zone];
    copy.usd = [self.usd copyWithZone:zone];
    
    return copy;
}
@end