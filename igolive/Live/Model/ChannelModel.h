//
//  ChannelModel.h
//  igolive
//
//  Created by greenhouse on 9/20/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagsModel.h"

@interface ChannelModel : NSObject

@property (nonatomic, retain) NSNumber *nChId;
@property (nonatomic, retain) NSString *strChannelName;
@property (nonatomic, retain) NSString *strWebHexColor;
@property (nonatomic, retain) UIColor *channelColor;
@property (nonatomic) unsigned channelColorInt;
@property (nonatomic, retain) NSArray<TagsModel *> *arrTags;
@property (nonatomic, retain) NSNumber *streamCount;

@property (nonatomic, retain) NSMutableArray<NewEmergingCollectionCellModel *> *arrStreams;
@property (nonatomic) int arrStreamsOffset;


- (id)initWithDictionary:(NSDictionary*)dict;

@end


