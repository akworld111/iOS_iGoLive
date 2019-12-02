//
//  NSDictionary+UrlEncoding.m
//
//  Created by joeyshen 8/9/16
//  Copyright (c) 2016 igo.live.  All rights reserved.
//

#import "NSDictionary+UrlEncoding.h"

static NSString *toString(id object) 
{
    return [NSString stringWithFormat:@"%@", object];
}

static NSString *urlEncode(id object)
{
    NSString *string = toString(object);
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

@implementation NSDictionary (UrlEncoding)

-(NSString*) urlEncodedString
{
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self)
    {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

@end