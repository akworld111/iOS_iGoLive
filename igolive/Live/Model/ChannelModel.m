//
//  ChannelModel.m
//  igolive
//
//  Created by greenhouse on 9/20/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "ChannelModel.h"

@implementation ChannelModel

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        self.nChId = [ObjectTypeValidator SAFEnsnumberFloatFromObject:dict[kChanId]];
        self.strChannelName = [ObjectTypeValidator SAFEnsstringFromObject:dict[kChanName]];
        
        self.strWebHexColor = [ObjectTypeValidator SAFEnsstringFromObject:dict[kChanColor]];
        if (self.strWebHexColor)
        {
            [self parseHexColorValue];
        }
        
        NSArray *arr = [ObjectTypeValidator nsarrayFromObject:dict[kTagsArr]];
        if (arr)
        {
            [self parseTagsArray:arr];
        }
        
        self.streamCount = [ObjectTypeValidator SAFEnsnumberFromObject:dict[kChanStreamCount]];
    }
    
    return self;
}

- (void)parseTagsArray:(NSArray*)arr
{
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:arr.count];
    
    for (id obj in arr)
    {
        NSDictionary *tagDict = [ObjectTypeValidator nsdictionaryFromObject:obj];
        if (tagDict)
        {
            TagsModel *tag = [[TagsModel alloc] initWithDictionary:tagDict];
            [mArr addObject:tag];
        }
    }
    
    self.arrTags = [NSArray arrayWithArray:mArr];
}
- (void)parseHexColorValue
{
    NSString *nativeHexColorStr = [MiscUtilities hexObjcStringFromHexWebString:self.strWebHexColor];
    self.channelColor = [MiscUtilities hexStringToUIColor:nativeHexColorStr];
    
    self.channelColorInt = [MiscUtilities hexIntFromHexString:nativeHexColorStr];
}

@end


