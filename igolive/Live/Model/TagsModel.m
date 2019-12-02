//
//  TagsModel.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/10.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "TagsModel.h"

NSString *const kTagsModelCtime = @"ctime";
NSString *const kTagsModelIdField = @"id";
NSString *const kTagsModelName = @"name";

@implementation TagsModel

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    // legacy
    if(![dictionary[kTagsModelCtime] isKindOfClass:[NSNull class]]){
        self.ctime = dictionary[kTagsModelCtime];
    }
    
    // legacy
    if(![dictionary[kTagsModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kTagsModelIdField];
    }
    
    // legacy
    if(![dictionary[kTagsModelName] isKindOfClass:[NSNull class]]){
        self.name = dictionary[kTagsModelName];
    }
    else
    {
        // new
        NSString *tagname = [ObjectTypeValidator nsstringFromObject:dictionary[kTagName]];
        if (tagname)
        {
            self.name = [NSString stringWithFormat:@"%@", tagname];
        }
    }
    
    // new
    NSNumber *channelId = [ObjectTypeValidator nsnumberIntFromObject:dictionary[kTagChId]];
    if(channelId){
        self.nChId = [NSNumber numberWithInteger:channelId.integerValue];
    }
    
    // new
    NSNumber *tagId = [ObjectTypeValidator nsnumberIntFromObject:dictionary[kTagId]];
    if(tagId){
        self.nTagId = [NSNumber numberWithInteger:tagId.integerValue];
    }

    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    // lagacy
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.ctime != nil){
        dictionary[kTagsModelCtime] = self.ctime;
    }
    
    // lagacy
    if(self.idField != nil){
        dictionary[kTagsModelIdField] = self.idField;
    }
    
    // lagacy
    if(self.name != nil){
        dictionary[kTagsModelName] = self.name;
        
        // new
        dictionary[kTagName] = self.name;
    }

    // new
    if(self.nChId != nil){
        dictionary[kTagChId] = self.ctime;
    }
    
    // new
    if(self.nTagId != nil){
        dictionary[kTagId] = self.idField;
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
    // legacy
    if(self.ctime != nil){
        [aCoder encodeObject:self.ctime forKey:kTagsModelCtime];
    }
    
    // legacy
    if(self.idField != nil){
        [aCoder encodeObject:self.idField forKey:kTagsModelIdField];
    }
    
    // legacy
    if(self.name != nil){
        [aCoder encodeObject:self.name forKey:kTagsModelName];
        
        // new
        [aCoder encodeObject:self.name forKey:kTagName];
    }
    
    // new
    if(self.nChId != nil){
        [aCoder encodeObject:self.nChId forKey:kTagChId];
    }
    
    // new
    if(self.nTagId != nil){
        [aCoder encodeObject:self.nTagId forKey:kTagId];
    }
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    // legacy
    self.ctime = [aDecoder decodeObjectForKey:kTagsModelCtime];
    self.idField = [aDecoder decodeObjectForKey:kTagsModelIdField];
    self.name = [aDecoder decodeObjectForKey:kTagsModelName];
    
    // new
    if (!self.name)
    {
        self.name = [aDecoder decodeObjectForKey:kTagName];
    }
    self.nChId = [ObjectTypeValidator nsnumberFromObject:[aDecoder decodeObjectForKey:kTagChId]];
    self.nTagId = [ObjectTypeValidator nsnumberFromObject:[aDecoder decodeObjectForKey:kTagId]];
    
    return self;
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    TagsModel *copy = [TagsModel new];
    
    copy.ctime = [self.ctime copyWithZone:zone];
    copy.idField = [self.idField copyWithZone:zone];
    copy.name = [self.name copyWithZone:zone];
    
    copy.nChId = [self.nChId copyWithZone:zone];
    copy.nTagId = [self.nTagId copyWithZone:zone];
    
    return copy;
}


@end


