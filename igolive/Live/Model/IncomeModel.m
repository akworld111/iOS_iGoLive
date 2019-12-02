//
//  IncomeModel.m
//  iphoneLive
//
//  Created by sdd on 16/8/18.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "IncomeModel.h"

@implementation IncomeModel

NSString *const kIncomeModelCanwithdraw = @"canwithdraw";
NSString *const kIncomeModelStars = @"stars";
NSString *const kIncomeModelStarsTotal = @"stars_total";
NSString *const kIncomeModelVotes = @"votes";
NSString *const kIncomeModelWithdraw = @"withdraw";





/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kIncomeModelCanwithdraw] isKindOfClass:[NSNull class]]){
        self.canwithdraw = [dictionary[kIncomeModelCanwithdraw] integerValue];
    }
    
    if(![dictionary[kIncomeModelStars] isKindOfClass:[NSNull class]]){
        self.stars = dictionary[kIncomeModelStars];
    }
    if(![dictionary[kIncomeModelStarsTotal] isKindOfClass:[NSNull class]]){
        self.starsTotal = dictionary[kIncomeModelStarsTotal];
    }
    if(![dictionary[kIncomeModelVotes] isKindOfClass:[NSNull class]]){
        self.votes = dictionary[kIncomeModelVotes];
    }
    if(![dictionary[kIncomeModelWithdraw] isKindOfClass:[NSNull class]]){
        self.withdraw = [dictionary[kIncomeModelWithdraw] integerValue];
    }
    
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kIncomeModelCanwithdraw] = @(self.canwithdraw);
    if(self.stars != nil){
        dictionary[kIncomeModelStars] = self.stars;
    }
    if(self.starsTotal != nil){
        dictionary[kIncomeModelStarsTotal] = self.starsTotal;
    }
    if(self.votes != nil){
        dictionary[kIncomeModelVotes] = self.votes;
    }
    dictionary[kIncomeModelWithdraw] = @(self.withdraw);
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
    [aCoder encodeObject:@(self.canwithdraw) forKey:kIncomeModelCanwithdraw];	if(self.stars != nil){
        [aCoder encodeObject:self.stars forKey:kIncomeModelStars];
    }
    if(self.starsTotal != nil){
        [aCoder encodeObject:self.starsTotal forKey:kIncomeModelStarsTotal];
    }
    if(self.votes != nil){
        [aCoder encodeObject:self.votes forKey:kIncomeModelVotes];
    }
    [aCoder encodeObject:@(self.withdraw) forKey:kIncomeModelWithdraw];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.canwithdraw = [[aDecoder decodeObjectForKey:kIncomeModelCanwithdraw] integerValue];
    self.stars = [aDecoder decodeObjectForKey:kIncomeModelStars];
    self.starsTotal = [aDecoder decodeObjectForKey:kIncomeModelStarsTotal];
    self.votes = [aDecoder decodeObjectForKey:kIncomeModelVotes];
    self.withdraw = [[aDecoder decodeObjectForKey:kIncomeModelWithdraw] integerValue];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    IncomeModel *copy = [IncomeModel new];
    
    copy.canwithdraw = self.canwithdraw;
    copy.stars = [self.stars copyWithZone:zone];
    copy.starsTotal = [self.starsTotal copyWithZone:zone];
    copy.votes = [self.votes copyWithZone:zone];
    copy.withdraw = self.withdraw;
    
    return copy;
}


@end
