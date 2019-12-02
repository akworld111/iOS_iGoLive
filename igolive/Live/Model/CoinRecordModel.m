//
//	CoinRecordModel.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CoinRecordModel.h"

NSString *const kCoinRecordModelAvatar = @"avatar";
NSString *const kCoinRecordModelGender = @"gender";
NSString *const kCoinRecordModelIsattention = @"isattention";
NSString *const kCoinRecordModelLevel = @"level";
NSString *const kCoinRecordModelTotal = @"total";
NSString *const kCoinRecordModelUid = @"uid";
NSString *const kCoinRecordModelUserNickname = @"user_nickname";

@interface CoinRecordModel ()
@end
@implementation CoinRecordModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!dictionary)
    {
        XLM_error(@"dictionary is nil; failed to initialize CoinRecordModel with parsed properties; returning instancetype with nil properties");
        return self;
    }

	if(![dictionary[kCoinRecordModelAvatar] isKindOfClass:[NSNull class]]){
		self.avatar = dictionary[kCoinRecordModelAvatar];
	}	
	if(![dictionary[kCoinRecordModelGender] isKindOfClass:[NSNull class]]){
		self.gender = dictionary[kCoinRecordModelGender];
	}	
	if(![dictionary[kCoinRecordModelIsattention] isKindOfClass:[NSNull class]]){
		self.isattention = [dictionary[kCoinRecordModelIsattention] integerValue];
	}

	if(![dictionary[kCoinRecordModelLevel] isKindOfClass:[NSNull class]]){
		self.level = dictionary[kCoinRecordModelLevel];
	}	
	if(![dictionary[kCoinRecordModelTotal] isKindOfClass:[NSNull class]]){
		self.total = dictionary[kCoinRecordModelTotal];
	}	
	if(![dictionary[kCoinRecordModelUid] isKindOfClass:[NSNull class]]){
		self.uid = dictionary[kCoinRecordModelUid];
	}	
	if(![dictionary[kCoinRecordModelUserNickname] isKindOfClass:[NSNull class]]){
		self.userNickname = dictionary[kCoinRecordModelUserNickname];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.avatar != nil){
		dictionary[kCoinRecordModelAvatar] = self.avatar;
	}
	if(self.gender != nil){
		dictionary[kCoinRecordModelGender] = self.gender;
	}
	dictionary[kCoinRecordModelIsattention] = @(self.isattention);
	if(self.level != nil){
		dictionary[kCoinRecordModelLevel] = self.level;
	}
	if(self.total != nil){
		dictionary[kCoinRecordModelTotal] = self.total;
	}
	if(self.uid != nil){
		dictionary[kCoinRecordModelUid] = self.uid;
	}
	if(self.userNickname != nil){
		dictionary[kCoinRecordModelUserNickname] = self.userNickname;
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
	if(self.avatar != nil){
		[aCoder encodeObject:self.avatar forKey:kCoinRecordModelAvatar];
	}
	if(self.gender != nil){
		[aCoder encodeObject:self.gender forKey:kCoinRecordModelGender];
	}
	[aCoder encodeObject:@(self.isattention) forKey:kCoinRecordModelIsattention];	if(self.level != nil){
		[aCoder encodeObject:self.level forKey:kCoinRecordModelLevel];
	}
	if(self.total != nil){
		[aCoder encodeObject:self.total forKey:kCoinRecordModelTotal];
	}
	if(self.uid != nil){
		[aCoder encodeObject:self.uid forKey:kCoinRecordModelUid];
	}
	if(self.userNickname != nil){
		[aCoder encodeObject:self.userNickname forKey:kCoinRecordModelUserNickname];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.avatar = [aDecoder decodeObjectForKey:kCoinRecordModelAvatar];
	self.gender = [aDecoder decodeObjectForKey:kCoinRecordModelGender];
	self.isattention = [[aDecoder decodeObjectForKey:kCoinRecordModelIsattention] integerValue];
	self.level = [aDecoder decodeObjectForKey:kCoinRecordModelLevel];
	self.total = [aDecoder decodeObjectForKey:kCoinRecordModelTotal];
	self.uid = [aDecoder decodeObjectForKey:kCoinRecordModelUid];
	self.userNickname = [aDecoder decodeObjectForKey:kCoinRecordModelUserNickname];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	CoinRecordModel *copy = [CoinRecordModel new];

	copy.avatar = [self.avatar copyWithZone:zone];
	copy.gender = [self.gender copyWithZone:zone];
	copy.isattention = self.isattention;
	copy.level = [self.level copyWithZone:zone];
	copy.total = [self.total copyWithZone:zone];
	copy.uid = [self.uid copyWithZone:zone];
	copy.userNickname = [self.userNickname copyWithZone:zone];

	return copy;
}
@end