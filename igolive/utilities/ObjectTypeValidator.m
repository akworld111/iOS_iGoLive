//
//  ObjectTypeValidator.m
//  igolive
//
//  Created by greenhouse on 8/27/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "ObjectTypeValidator.h"
#import "StringConstantDefines.h"

@implementation ObjectTypeValidator


////////////////////////////////////
#pragma mark - igolive specific
////////////////////////////////////
+ (ChannelModel*)channelmodelFromObj:(id)obj
{
    if (!obj || ![obj isKindOfClass:[ChannelModel class]])
    {
        XLM_error(@"obj is nil or not of type ChannelModel; returning nil");
        return nil;
    }
    
    return (ChannelModel*)obj;
}
+ (GiftItem*)IGOGiftItemFromObj:(id)obj
{
    if (!obj || ![obj isKindOfClass:[GiftItem class]])
    {
        XLM_error(@"obj is nil or not of type GiftItem; returning nil");
        return nil;
    }
    
    return (GiftItem*)obj;
}


////////////////////////////////////
#pragma mark - general
////////////////////////////////////
+ (UIScrollView*)uiscrollviewFromObject:(id)obj
{
    if (!obj || ![obj isKindOfClass:[UIScrollView class]])
    {
        return nil;
    }
    
    return (UIScrollView*)obj;
}
+ (UIImageView*)uiimageviewFromObject:(id)obj
{
    if (!obj || ![obj isKindOfClass:[UIImageView class]])
    {
        return nil;
    }
    
    return (UIImageView*)obj;
}
+ (UIView*)uiviewFromObject:(id)obj
{
    if (!obj || ![obj isKindOfClass:[UIView class]])
    {
        return nil;
    }
    
    return (UIView*)obj;
}
+ (id)objectFromNSArray:(NSArray*)arr atIndex:(NSInteger)index
{
    if (!arr || index >= arr.count)
    {
        XLM_error(@"arr is nil or index >= arr.count; returning nil");
        return nil;
    }
    
    return [arr objectAtIndex:index];
}
+ (BOOL)nsstringIsNil:(NSString*)str
{
    if (!str)
    {
        return YES;
    }
    
    return NO;
}
+ (BOOL)nsstringIsNilOrEmpty:(NSString*)str
{
    if (!str || [str isEqualToString:@""])
    {
        return YES;
    }
    
    return NO;
}
+ (BOOL)isValidStreetFormat:(NSString*)strstreet
{
    if ([ObjectTypeValidator nsstringIsNilOrEmpty:strstreet]
        || strstreet.length < 1)
    {
        return NO;
    }
    return YES;
}
+ (BOOL)isValidAptSuiteFormat:(NSString*)straptsuite
{
    if ([ObjectTypeValidator nsstringIsNilOrEmpty:straptsuite]
        || straptsuite.length < 1)
    {
        return NO;
    }
    return YES;
}
+ (BOOL)isValidCityFormat:(NSString*)strcity
{
    if ([ObjectTypeValidator nsstringIsNilOrEmpty:strcity]
        || strcity.length < 1)
    {
        return NO;
    }
    return YES;
}
+ (BOOL)isValidStateFormat:(NSString*)strstate
{
    if ([ObjectTypeValidator nsstringIsNilOrEmpty:strstate]
        || strstate.length != 2)
    {
        return NO;
    }
    return YES;
}
+ (BOOL)isValidZipFormat:(NSString*)strzip
{
    if ([ObjectTypeValidator nsstringIsNilOrEmpty:strzip]
        || strzip.length != 5)
    {
        return NO;
    }
    return YES;
}
+ (NSString*)nsstringFromNSInteger:(NSInteger)integer useTwoCharForZero:(BOOL)useTwoCharForZero
{
    if (useTwoCharForZero)
        return integer == 0 ? @"00" : [NSString stringWithFormat:@"%li", (long)integer];
    
    return [NSString stringWithFormat:@"%li", (long)integer];
}
+ (BOOL)nsdateIsPM:(NSDate*)date
{
    if (!date)
    {
        XLog(@"warning: date == nil; returning NO");
        return NO;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *hours = [dateFormatter stringFromDate:date];
    
    // note: according to logs, this algorithm should not be working,
    //  but the UI shows its fine (moon/sun displayed accordingly)
    if (hours.integerValue > 11)
        return YES;
    
    return NO;
}
+ (NSString*)nsstringFromNSDate:(NSDate*)date format:(NSString*)format
{
    if (!date)
    {
        XLog(@"warning: date == nil; failed to get date string; return garbage");
        return @"time_error";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    //[dateFormatter setAMSymbol:@"am"];
    //[dateFormatter setPMSymbol:@"pm"];
    
    NSString *time = [dateFormatter stringFromDate:date];
    return time;
}
+ (NSString*)nsstringFullTimeFormatFromNSDate:(NSDate*)date
{
    if (!date)
    {
        XLog(@"warning: date == nil; failed to get date string; return garbage");
        return @"time_error";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:str_dateformat_h_mm_ss_a];
    
    NSString *time = [dateFormatter stringFromDate:date];
    return time;
}
+ (NSString*)nsstringDateFormatFromNSDate:(NSDate*)date
{
    if (!date)
    {
        XLog(@"warning: date == nil; failed to get date string; return garbage");
        return @"date_error";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy"];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    
    NSLog(@"Date for locale %@: %@",
          [[dateFormatter locale] localeIdentifier], [dateFormatter stringFromDate:date]);
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
    
}
+ (NSDate*)nsdateFromObject:(id)obj
{
    if (obj)
    {
        // first cast to raw NSInteger (long)
        //  then check if NSNumber can be used
        NSInteger sec = (NSInteger)obj;
        
        if ([obj isKindOfClass:[NSNumber class]])
        {
            NSNumber *nSec = (NSNumber*)obj;
            sec = [nSec integerValue];
        }
        
        return [NSDate dateWithTimeIntervalSince1970:sec]; // warning: datesince1970 takes a double (NSTimeInterval)
    }
    
    XLog("WARNING: obj is nil; returning date 'now'");
    return [NSDate dateWithTimeIntervalSinceNow:0.0f];
}
+ (NSDate*)nsdateFromMilliSecObject:(id)mSecObj
{
    if (mSecObj)
    {
        // first cast to raw NSInteger (long)
        //  then check if NSNumber can be used
        NSInteger millisec = (NSInteger)mSecObj;
        NSInteger sec = millisec / 1000;
        
        if ([mSecObj isKindOfClass:[NSNumber class]])
        {
            NSNumber *nmillisec = (NSNumber*)mSecObj;
            NSNumber *nsec = [NSNumber numberWithInteger:nmillisec.integerValue / 1000];
            sec = [nsec integerValue];
        }
        
        return [NSDate dateWithTimeIntervalSince1970:sec]; // warning: datesince1970 takes a double (NSTimeInterval)
    }
    
    XLog("WARNING: mSecObj is nil; returning date 'now'");
    return [NSDate dateWithTimeIntervalSinceNow:0.0f];
}
+ (NSNumber*)nsnumberMillisecFromNSNumberSec:(NSNumber*)sec
{
    if (!sec){
        XLog("WARNING: nsnumber sec is nil; returning nil");
        return nil;
    }
    
    
    return [NSNumber numberWithInteger:sec.integerValue * 1000];
}
+ (NSNumber*)nsnumberMillisecFromIntegerSec:(NSInteger)sec
{
    return [NSNumber numberWithInteger:sec * 1000];
}
+ (NSNumber*)nsnumberMillisecFromDoubleSec:(double)sec
{
    return [NSNumber numberWithInteger:sec * 1000];
}
+ (NSNumber*)nsnumberSecFromNSNumberMillisec:(NSNumber*)msec
{
    if (!msec)
        return nil;
    
    return [NSNumber numberWithInteger:msec.integerValue / 1000];
}
+ (NSInteger)nsintegerFromObject:(id)obj
{
    NSInteger intReturn = -1;
    if (obj)
    {
        // first cast to raw NSInteger (long)
        //  then check if NSNumber can be used
        intReturn = (NSInteger)obj;
        
        if ([obj isKindOfClass:[NSNumber class]])
        {
            NSNumber *nObj = (NSNumber*)obj;
            intReturn = [nObj integerValue];
        }
        
        return intReturn;
    }
    
    XLM_warning("obj is nil; returning -1");
    return intReturn;
}
+ (NSNumber*)SAFEnsnumberBoolFromObject:(id)obj
{
    if (!obj)
    {
        XLM_warning(@"obj is nil; returning number with NO");
        return [NSNumber numberWithBool:NO];
    }
    
    NSNumber *nbool = [ObjectTypeValidator nsnumberFromObject:obj];
    if (nbool.intValue == 0 || nbool.intValue == 1) // i think this does the trick? : O
    {
        return nbool;
    }
    
    XLM_error(@"obj is not nil but not a 1 or 0 either; returning number with no");
    return [NSNumber numberWithBool:NO];
}
+ (NSNumber*)SAFEnsnumberFloatFromObject:(id)obj
{
    NSNumber *toreturn = [ObjectTypeValidator nsnumberFloatFromObject:obj];
    toreturn = toreturn ? toreturn : [NSNumber numberWithFloat:-1.0f];
    return toreturn;
}
+ (NSNumber*)SAFEnsnumberIntFromObject:(id)obj
{
    NSNumber *toreturn = [ObjectTypeValidator nsnumberIntFromObject:obj];
    toreturn = toreturn ? toreturn : [NSNumber numberWithInt:-1];
    return toreturn;
}
+ (NSNumber*)SAFEnsnumberFromObject:(id)obj
{
    NSNumber *toreturn = [ObjectTypeValidator nsnumberFromObject:obj];
    //if (!toreturn)
    //    XLM_warning(@"returning -1; this means that the object FAILED to cast to both an NSNumber and an NSString");
    
    toreturn = toreturn ? toreturn : [NSNumber numberWithInt:-1];
    return toreturn;
}
+ (NSNumber*)nsnumberFloatFromObject:(id)obj
{
    if (obj)
    {
        if ([obj isKindOfClass:[NSNumber class]])
        {
            NSNumber *num = (NSNumber*)obj;
            return num;
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            NSString *strNum = (NSString*)obj;
            NSNumber *num = [NSNumber numberWithFloat:strNum.floatValue];
            
            // short hand
            //NSNumber *num = @([strNum integerValue]);
            
            //XLM_warning(@"casting to NSString was first required; casting to float; loses original memory address");
            return num;
        }
    }
    
    //XLM_error(@"returning nil; this means that the object FAILED to cast to both an NSNumber and an NSString");
    return nil;
}
+ (NSNumber*)nsnumberIntFromObject:(id)obj
{
    if (obj)
    {
        if ([obj isKindOfClass:[NSNumber class]])
        {
            NSNumber *num = (NSNumber*)obj;
            return num;
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            NSString *strNum = (NSString*)obj;
            NSNumber *num = [NSNumber numberWithLongLong:strNum.longLongValue];
            
            // short hand
            //NSNumber *num = @([strNum integerValue]);
            
            //XLM_warning(@"casting to NSString was first required; casting to LongLong; loses float/double precision; loses original memory address");
            return num;
        }
    }
    
    //XLM_error(@"returning nil; this means that the object FAILED to cast to both an NSNumber and an NSString");
    return nil;
}
+ (NSNumber*)nsnumberFromObject:(id)obj
{
    if (obj)
    {
        if ([obj isKindOfClass:[NSNumber class]])
        {
            NSNumber *num = (NSNumber*)obj;
            return num;
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            NSString *strNum = (NSString*)obj;
            NSNumber *num = [NSNumber numberWithLongLong:strNum.longLongValue];
            
            // short hand
            //NSNumber *num = @([strNum integerValue]);
            
            XLM_warning(@"casting to NSString was first required; current implementation casts to LongLong; loses float/double precision; loses original memory address");
            return num;
        }
    }
    
    //XLM_error(@"returning nil; this means that the object FAILED to cast to both an NSNumber and an NSString");
    return nil;
}
+ (NSMutableDictionary*)SAFEnsmutabledictionaryFromObject:(id)obj
{
    NSDictionary *dict = [ObjectTypeValidator nsdictionaryFromObject:obj];
    if (!dict)
        return [NSMutableDictionary dictionary];
    
    return [NSMutableDictionary dictionaryWithDictionary:dict];
}
+ (NSDictionary*)SAFEnsdictionaryFromObject:(id)obj
{
    NSDictionary *dict = [ObjectTypeValidator nsdictionaryFromObject:obj];
    if (!dict)
        return [NSDictionary dictionary];
    
    return [NSDictionary dictionaryWithDictionary:dict];
}
+ (NSDictionary*)nsdictionaryFromObject:(id)obj
{
    NSString *strDict = [ObjectTypeValidator nsstringFromObject:obj];
    if (strDict)
    {
        NSData *data = [strDict dataUsingEncoding:NSUTF8StringEncoding];
        obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    
    if (obj && [obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objd = (NSDictionary*)obj;
        return [NSDictionary dictionaryWithDictionary:objd];
    }
    
    XLM_error(@"obj parsing to NSDictionary failed; returning nil\n\n");
    return nil;
}
+ (NSString*)SAFEnsstringFromObject:(id)obj
{
    NSString *toreturn = [ObjectTypeValidator nsstringFromObject:obj];
    toreturn = toreturn ? toreturn : @"";
    return toreturn;
}
+ (NSString*)nsstringFromObject:(id)obj
{
    if (obj && [obj isKindOfClass:[NSString class]])
    {
        NSString *str = (NSString*)obj;
        return [NSString stringWithString:str];
    }
    
    return nil;
}
+ (NSArray*)nsarrayFromObject:(id)obj
{
    if (obj && [obj isKindOfClass:[NSArray class]])
    {
        return (NSArray*)obj;
    }
    
    XLM_error(@"obj failed validation; returning nil");
    return nil;
}
+ (BOOL)nsarrayIsNilOrEmpty:(NSArray*)arr
{
    if (![ObjectTypeValidator nsarrayFromObject:arr])
        return YES;
    if (arr.count < 1)
        return YES;
    return NO;
}
+ (NSNumber*)nsnumberFromNSString:(NSString*)str
{
    if (!str || [str isEqualToString:@""])
        return nil;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterNoStyle;
    NSNumber *nStr = [f numberFromString:str];
    
    return nStr;
}
+ (NSDictionary*)nsdictionaryFromSingleCountArrayObj:(id)obj
{
    if (obj && [obj isKindOfClass:[NSArray class]])
    {
        NSArray *arr = (NSArray*)obj;
        if (arr.count > 1)
        {
            XLM_warning(@"single count array has %li objects; only utilizing arr[0]", (unsigned long)arr.count);
        }
        
        if (arr.count > 0)
        {
            id aObj = arr[0];
            if (aObj && [aObj isKindOfClass:[NSDictionary class]])
            {
                return (NSDictionary*)aObj;
            }
        }
    }
    
    XLM_error(@"single count aObj is nil, is not of type NSArray, or count is less than 1; returning nil");
    return nil;
}
+ (NSValue*)nsvalueFromObject:(id)obj
{
    if (obj && [obj isKindOfClass:[NSValue class]])
    {
        return (NSValue*)obj;
    }
    
    return nil;
}
+ (NSArray*)nsstringArrayFromNSNumberArray:(NSArray*)nsnumArray
{
    XL_enter();
    
    if (!nsnumArray || nsnumArray.count < 1)
    {
        XLM_error(@"param nsnumarray is empty or nil; returning nil");
        return nil;
    }
    
    NSMutableArray *mNSNumArray = [NSMutableArray arrayWithCapacity:nsnumArray.count];
    for (int x = 0; x < nsnumArray.count; x++)
    {
        id obj = nsnumArray[x];
        NSNumber *nObj = [ObjectTypeValidator nsnumberFromObject:obj];
        if (nObj)
        {
            NSString *strObj = nObj.stringValue;
            [mNSNumArray addObject:strObj];
        }
        else
        {
            XLM_error(@"object at index %i is not of type nsnumber; continuing with the rest of the array", x);
        }
    }
    
    return [NSArray arrayWithArray:mNSNumArray];
}
+ (NSString*)firstnameFromFullnameString:(NSString*)fullname
{
    if (!fullname || [fullname isEqualToString:@""])
    {
        XLM_error(@"fullname parameter is nil or an empty string; returning empty string");
        return @"";
    }
    
    NSArray *strings = [fullname componentsSeparatedByString:@" "];
    
    if (strings.count > 0)
    {
        return strings[0];
    }
    else
    {
        return @"";
    }
}
// note: returns everything after the first " " (space) as a last name string
+ (NSString*)lastnameFromFullnameString:(NSString*)fullname
{
    if (!fullname || [fullname isEqualToString:@""])
    {
        XLM_error(@"fullname parameter is nil or an empty string; returning nil");
        return @"";
    }
    
    NSArray *strings = [fullname componentsSeparatedByString:@" "];
    
    if (strings.count == 1)
    {
        return @"";
    }
    
    NSString *lastname = nil;
    if (strings.count > 1)
    {
        for (int x = 1; x < strings.count; x++)
        {
            if (!lastname)
                lastname = strings[x];
            else
                lastname = [NSString stringWithFormat:@"%@ %@", lastname, strings[x]];
        }
    }
    
    return lastname;
    
}


@end


