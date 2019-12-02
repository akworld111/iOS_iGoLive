//
//  GiftsModel.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/7.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "GiftsModel.h"

NSString *const kGiftsModelAddtime = @"addtime";
NSString *const kGiftsModelExperience = @"experience";
NSString *const kGiftsModelGifticon = @"gifticon";
NSString *const kGiftsModelGifticonMini = @"gifticon_mini";
NSString *const kGiftsModelGiftname = @"giftname";
NSString *const kGiftsModelIdField = @"id";
NSString *const kGiftsModelNeedcoin = @"needcoin";
NSString *const kGiftsModelOrderno = @"orderno";
NSString *const kGiftsModelSid = @"sid";
NSString *const kGiftsModelType = @"type";

@implementation GiftsModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kGiftsModelAddtime] isKindOfClass:[NSNull class]]){
        self.addtime = dictionary[kGiftsModelAddtime];
    }
    if(![dictionary[kGiftsModelExperience] isKindOfClass:[NSNull class]]){
        self.experience = dictionary[kGiftsModelExperience];
    }
    if(![dictionary[kGiftsModelGifticon] isKindOfClass:[NSNull class]]){
        self.gifticon = dictionary[kGiftsModelGifticon];
    }
    if(![dictionary[kGiftsModelGifticonMini] isKindOfClass:[NSNull class]]){
        self.gifticonMini = dictionary[kGiftsModelGifticonMini];
    }
    if(![dictionary[kGiftsModelGiftname] isKindOfClass:[NSNull class]]){
        self.giftname = dictionary[kGiftsModelGiftname];
    }
    if(![dictionary[kGiftsModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kGiftsModelIdField];
    }
    if(![dictionary[kGiftsModelNeedcoin] isKindOfClass:[NSNull class]]){
        self.needcoin = dictionary[kGiftsModelNeedcoin];
    }
    if(![dictionary[kGiftsModelOrderno] isKindOfClass:[NSNull class]]){
        self.orderno = dictionary[kGiftsModelOrderno];
    }
    if(![dictionary[kGiftsModelSid] isKindOfClass:[NSNull class]]){
        self.sid = dictionary[kGiftsModelSid];
    }
    if(![dictionary[kGiftsModelType] isKindOfClass:[NSNull class]]){
        self.type = dictionary[kGiftsModelType];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.addtime != nil){
        dictionary[kGiftsModelAddtime] = self.addtime;
    }
    if(self.experience != nil){
        dictionary[kGiftsModelExperience] = self.experience;
    }
    if(self.gifticon != nil){
        dictionary[kGiftsModelGifticon] = self.gifticon;
    }
    if(self.gifticonMini != nil){
        dictionary[kGiftsModelGifticonMini] = self.gifticonMini;
    }
    if(self.giftname != nil){
        dictionary[kGiftsModelGiftname] = self.giftname;
    }
    if(self.idField != nil){
        dictionary[kGiftsModelIdField] = self.idField;
    }
    if(self.needcoin != nil){
        dictionary[kGiftsModelNeedcoin] = self.needcoin;
    }
    if(self.orderno != nil){
        dictionary[kGiftsModelOrderno] = self.orderno;
    }
    if(self.sid != nil){
        dictionary[kGiftsModelSid] = self.sid;
    }
    if(self.type != nil){
        dictionary[kGiftsModelType] = self.type;
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
    if(self.addtime != nil){
        [aCoder encodeObject:self.addtime forKey:kGiftsModelAddtime];
    }
    if(self.experience != nil){
        [aCoder encodeObject:self.experience forKey:kGiftsModelExperience];
    }
    if(self.gifticon != nil){
        [aCoder encodeObject:self.gifticon forKey:kGiftsModelGifticon];
    }
    if(self.gifticonMini != nil){
        [aCoder encodeObject:self.gifticonMini forKey:kGiftsModelGifticonMini];
    }
    if(self.giftname != nil){
        [aCoder encodeObject:self.giftname forKey:kGiftsModelGiftname];
    }
    if(self.idField != nil){
        [aCoder encodeObject:self.idField forKey:kGiftsModelIdField];
    }
    if(self.needcoin != nil){
        [aCoder encodeObject:self.needcoin forKey:kGiftsModelNeedcoin];
    }
    if(self.orderno != nil){
        [aCoder encodeObject:self.orderno forKey:kGiftsModelOrderno];
    }
    if(self.sid != nil){
        [aCoder encodeObject:self.sid forKey:kGiftsModelSid];
    }
    if(self.type != nil){
        [aCoder encodeObject:self.type forKey:kGiftsModelType];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.addtime = [aDecoder decodeObjectForKey:kGiftsModelAddtime];
    self.experience = [aDecoder decodeObjectForKey:kGiftsModelExperience];
    self.gifticon = [aDecoder decodeObjectForKey:kGiftsModelGifticon];
    self.gifticonMini = [aDecoder decodeObjectForKey:kGiftsModelGifticonMini];
    self.giftname = [aDecoder decodeObjectForKey:kGiftsModelGiftname];
    self.idField = [aDecoder decodeObjectForKey:kGiftsModelIdField];
    self.needcoin = [aDecoder decodeObjectForKey:kGiftsModelNeedcoin];
    self.orderno = [aDecoder decodeObjectForKey:kGiftsModelOrderno];
    self.sid = [aDecoder decodeObjectForKey:kGiftsModelSid];
    self.type = [aDecoder decodeObjectForKey:kGiftsModelType];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    GiftsModel *copy = [GiftsModel new];
    
    copy.addtime = [self.addtime copyWithZone:zone];
    copy.experience = [self.experience copyWithZone:zone];
    copy.gifticon = [self.gifticon copyWithZone:zone];
    copy.gifticonMini = [self.gifticonMini copyWithZone:zone];
    copy.giftname = [self.giftname copyWithZone:zone];
    copy.idField = [self.idField copyWithZone:zone];
    copy.needcoin = [self.needcoin copyWithZone:zone];
    copy.orderno = [self.orderno copyWithZone:zone];
    copy.sid = [self.sid copyWithZone:zone];
    copy.type = [self.type copyWithZone:zone];
    
    return copy;
}
@end