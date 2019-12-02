//
//  TagsModel.h
//  iphoneLive
//
//  Created by 高翔 on 16/8/10.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagsModel : NSObject

@property (nonatomic, strong) NSString * ctime;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * name;

@property (nonatomic, retain) NSNumber *nChId;
@property (nonatomic, retain) NSNumber *nTagId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
