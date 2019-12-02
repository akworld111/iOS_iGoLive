//
//	RecordedListModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "RecordedListModel.h"

NSString *const kRecordedListModelAddress = @"address";
NSString *const kRecordedListModelCity = @"city";
NSString *const kRecordedListModelDatetime = @"datetime";
NSString *const kRecordedListModelEndtime = @"endtime";
NSString *const kRecordedListModelIdField = @"id";
NSString *const kRecordedListModelIslive = @"islive";
NSString *const kRecordedListModelLight = @"light";
NSString *const kRecordedListModelNums = @"nums";
NSString *const kRecordedListModelProvince = @"province";
NSString *const kRecordedListModelShowid = @"showid";
NSString *const kRecordedListModelStarttime = @"starttime";
NSString *const kRecordedListModelTags = @"tags";
NSString *const kRecordedListModelTitle = @"title";
NSString *const kRecordedListModelUid = @"uid";

@interface RecordedListModel ()
@end
@implementation RecordedListModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kRecordedListModelAddress] isKindOfClass:[NSNull class]]){
        self.address = dictionary[kRecordedListModelAddress];
    }
    if(![dictionary[kRecordedListModelCity] isKindOfClass:[NSNull class]]){
        self.city = dictionary[kRecordedListModelCity];
    }
    if(![dictionary[kRecordedListModelDatetime] isKindOfClass:[NSNull class]]){
        self.datetime = dictionary[kRecordedListModelDatetime];
    }
    if(![dictionary[kRecordedListModelEndtime] isKindOfClass:[NSNull class]]){
        self.endtime = dictionary[kRecordedListModelEndtime];
    }
    if(![dictionary[kRecordedListModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kRecordedListModelIdField];
    }
    if(![dictionary[kRecordedListModelIslive] isKindOfClass:[NSNull class]]){
        self.islive = dictionary[kRecordedListModelIslive];
    }
    if(![dictionary[kRecordedListModelLight] isKindOfClass:[NSNull class]]){
        self.light = dictionary[kRecordedListModelLight];
    }
    if(![dictionary[kRecordedListModelNums] isKindOfClass:[NSNull class]]){
        self.nums = dictionary[kRecordedListModelNums];
    }
    if(![dictionary[kRecordedListModelProvince] isKindOfClass:[NSNull class]]){
        self.province = dictionary[kRecordedListModelProvince];
    }
    if(![dictionary[kRecordedListModelShowid] isKindOfClass:[NSNull class]]){
        self.showid = dictionary[kRecordedListModelShowid];
    }
    if(![dictionary[kRecordedListModelStarttime] isKindOfClass:[NSNull class]]){
        self.starttime = dictionary[kRecordedListModelStarttime];
    }
    if(![dictionary[kRecordedListModelTags] isKindOfClass:[NSNull class]]){
        self.tags = dictionary[kRecordedListModelTags];
    }
    if(![dictionary[kRecordedListModelTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kRecordedListModelTitle];
    }
    if(![dictionary[kRecordedListModelUid] isKindOfClass:[NSNull class]]){
        self.uid = dictionary[kRecordedListModelUid];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.address != nil){
        dictionary[kRecordedListModelAddress] = self.address;
    }
    if(self.city != nil){
        dictionary[kRecordedListModelCity] = self.city;
    }
    if(self.datetime != nil){
        dictionary[kRecordedListModelDatetime] = self.datetime;
    }
    if(self.endtime != nil){
        dictionary[kRecordedListModelEndtime] = self.endtime;
    }
    if(self.idField != nil){
        dictionary[kRecordedListModelIdField] = self.idField;
    }
    if(self.islive != nil){
        dictionary[kRecordedListModelIslive] = self.islive;
    }
    if(self.light != nil){
        dictionary[kRecordedListModelLight] = self.light;
    }
    if(self.nums != nil){
        dictionary[kRecordedListModelNums] = self.nums;
    }
    if(self.province != nil){
        dictionary[kRecordedListModelProvince] = self.province;
    }
    if(self.showid != nil){
        dictionary[kRecordedListModelShowid] = self.showid;
    }
    if(self.starttime != nil){
        dictionary[kRecordedListModelStarttime] = self.starttime;
    }
    if(self.tags != nil){
        dictionary[kRecordedListModelTags] = self.tags;
    }
    if(self.title != nil){
        dictionary[kRecordedListModelTitle] = self.title;
    }
    if(self.uid != nil){
        dictionary[kRecordedListModelUid] = self.uid;
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
    if(self.address != nil){
        [aCoder encodeObject:self.address forKey:kRecordedListModelAddress];
    }
    if(self.city != nil){
        [aCoder encodeObject:self.city forKey:kRecordedListModelCity];
    }
    if(self.datetime != nil){
        [aCoder encodeObject:self.datetime forKey:kRecordedListModelDatetime];
    }
    if(self.endtime != nil){
        [aCoder encodeObject:self.endtime forKey:kRecordedListModelEndtime];
    }
    if(self.idField != nil){
        [aCoder encodeObject:self.idField forKey:kRecordedListModelIdField];
    }
    if(self.islive != nil){
        [aCoder encodeObject:self.islive forKey:kRecordedListModelIslive];
    }
    if(self.light != nil){
        [aCoder encodeObject:self.light forKey:kRecordedListModelLight];
    }
    if(self.nums != nil){
        [aCoder encodeObject:self.nums forKey:kRecordedListModelNums];
    }
    if(self.province != nil){
        [aCoder encodeObject:self.province forKey:kRecordedListModelProvince];
    }
    if(self.showid != nil){
        [aCoder encodeObject:self.showid forKey:kRecordedListModelShowid];
    }
    if(self.starttime != nil){
        [aCoder encodeObject:self.starttime forKey:kRecordedListModelStarttime];
    }
    if(self.tags != nil){
        [aCoder encodeObject:self.tags forKey:kRecordedListModelTags];
    }
    if(self.title != nil){
        [aCoder encodeObject:self.title forKey:kRecordedListModelTitle];
    }
    if(self.uid != nil){
        [aCoder encodeObject:self.uid forKey:kRecordedListModelUid];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.address = [aDecoder decodeObjectForKey:kRecordedListModelAddress];
    self.city = [aDecoder decodeObjectForKey:kRecordedListModelCity];
    self.datetime = [aDecoder decodeObjectForKey:kRecordedListModelDatetime];
    self.endtime = [aDecoder decodeObjectForKey:kRecordedListModelEndtime];
    self.idField = [aDecoder decodeObjectForKey:kRecordedListModelIdField];
    self.islive = [aDecoder decodeObjectForKey:kRecordedListModelIslive];
    self.light = [aDecoder decodeObjectForKey:kRecordedListModelLight];
    self.nums = [aDecoder decodeObjectForKey:kRecordedListModelNums];
    self.province = [aDecoder decodeObjectForKey:kRecordedListModelProvince];
    self.showid = [aDecoder decodeObjectForKey:kRecordedListModelShowid];
    self.starttime = [aDecoder decodeObjectForKey:kRecordedListModelStarttime];
    self.tags = [aDecoder decodeObjectForKey:kRecordedListModelTags];
    self.title = [aDecoder decodeObjectForKey:kRecordedListModelTitle];
    self.uid = [aDecoder decodeObjectForKey:kRecordedListModelUid];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    RecordedListModel *copy = [RecordedListModel new];
    
    copy.address = [self.address copyWithZone:zone];
    copy.city = [self.city copyWithZone:zone];
    copy.datetime = [self.datetime copyWithZone:zone];
    copy.endtime = [self.endtime copyWithZone:zone];
    copy.idField = [self.idField copyWithZone:zone];
    copy.islive = [self.islive copyWithZone:zone];
    copy.light = [self.light copyWithZone:zone];
    copy.nums = [self.nums copyWithZone:zone];
    copy.province = [self.province copyWithZone:zone];
    copy.showid = [self.showid copyWithZone:zone];
    copy.starttime = [self.starttime copyWithZone:zone];
    copy.tags = [self.tags copyWithZone:zone];
    copy.title = [self.title copyWithZone:zone];
    copy.uid = [self.uid copyWithZone:zone];
    
    return copy;
}
@end