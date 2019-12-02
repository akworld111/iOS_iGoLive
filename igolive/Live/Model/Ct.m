//
//	Ct.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Ct.h"

NSString *const kCtAction = @"action";
NSString *const kCtAddtime = @"addtime";
NSString *const kCtAvatar = @"avatar";
NSString *const kCtGiftcount = @"giftcount";
NSString *const kCtGifticon = @"gifticon";
NSString *const kCtGiftid = @"giftid";
NSString *const kCtGiftname = @"giftname";
NSString *const kCtGifttoken = @"gifttoken";
NSString *const kCtLevel = @"level";
NSString *const kCtNicename = @"nicename";
NSString *const kCtShowid = @"showid";
NSString *const kCtTotalcoin = @"totalcoin";
NSString *const kCtTouid = @"touid";
NSString *const kCtType = @"type";
NSString *const kCtUid = @"uid";

@interface Ct ()
@end
@implementation Ct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kCtAction] isKindOfClass:[NSNull class]]){
		self.action = dictionary[kCtAction];
	}	
	if(![dictionary[kCtAddtime] isKindOfClass:[NSNull class]]){
		self.addtime = [dictionary[kCtAddtime] integerValue];
	}

	if(![dictionary[kCtAvatar] isKindOfClass:[NSNull class]]){
		self.avatar = dictionary[kCtAvatar];
	}	
	if(![dictionary[kCtGiftcount] isKindOfClass:[NSNull class]]){
		self.giftcount = [dictionary[kCtGiftcount] integerValue];
	}

	if(![dictionary[kCtGifticon] isKindOfClass:[NSNull class]]){
		self.gifticon = dictionary[kCtGifticon];
	}	
	if(![dictionary[kCtGiftid] isKindOfClass:[NSNull class]]){
		self.giftid = [dictionary[kCtGiftid] integerValue];
	}

	if(![dictionary[kCtGiftname] isKindOfClass:[NSNull class]]){
		self.giftname = dictionary[kCtGiftname];
	}	
	if(![dictionary[kCtGifttoken] isKindOfClass:[NSNull class]]){
		self.gifttoken = dictionary[kCtGifttoken];
	}	
	if(![dictionary[kCtLevel] isKindOfClass:[NSNull class]]){
		self.level = dictionary[kCtLevel];
	}	
	if(![dictionary[kCtNicename] isKindOfClass:[NSNull class]]){
		self.nicename = dictionary[kCtNicename];
	}	
	if(![dictionary[kCtShowid] isKindOfClass:[NSNull class]]){
		self.showid = [dictionary[kCtShowid] integerValue];
	}

	if(![dictionary[kCtTotalcoin] isKindOfClass:[NSNull class]]){
		self.totalcoin = [dictionary[kCtTotalcoin] integerValue];
	}

	if(![dictionary[kCtTouid] isKindOfClass:[NSNull class]]){
		self.touid = [dictionary[kCtTouid] integerValue];
	}

	if(![dictionary[kCtType] isKindOfClass:[NSNull class]]){
		self.type = dictionary[kCtType];
	}	
	if(![dictionary[kCtUid] isKindOfClass:[NSNull class]]){
		self.uid = [dictionary[kCtUid] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.action != nil){
		dictionary[kCtAction] = self.action;
	}
	dictionary[kCtAddtime] = @(self.addtime);
	if(self.avatar != nil){
		dictionary[kCtAvatar] = self.avatar;
	}
	dictionary[kCtGiftcount] = @(self.giftcount);
	if(self.gifticon != nil){
		dictionary[kCtGifticon] = self.gifticon;
	}
	dictionary[kCtGiftid] = @(self.giftid);
	if(self.giftname != nil){
		dictionary[kCtGiftname] = self.giftname;
	}
	if(self.gifttoken != nil){
		dictionary[kCtGifttoken] = self.gifttoken;
	}
	if(self.level != nil){
		dictionary[kCtLevel] = self.level;
	}
	if(self.nicename != nil){
		dictionary[kCtNicename] = self.nicename;
	}
	dictionary[kCtShowid] = @(self.showid);
	dictionary[kCtTotalcoin] = @(self.totalcoin);
	dictionary[kCtTouid] = @(self.touid);
	if(self.type != nil){
		dictionary[kCtType] = self.type;
	}
	dictionary[kCtUid] = @(self.uid);
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
	if(self.action != nil){
		[aCoder encodeObject:self.action forKey:kCtAction];
	}
	[aCoder encodeObject:@(self.addtime) forKey:kCtAddtime];	if(self.avatar != nil){
		[aCoder encodeObject:self.avatar forKey:kCtAvatar];
	}
	[aCoder encodeObject:@(self.giftcount) forKey:kCtGiftcount];	if(self.gifticon != nil){
		[aCoder encodeObject:self.gifticon forKey:kCtGifticon];
	}
	[aCoder encodeObject:@(self.giftid) forKey:kCtGiftid];	if(self.giftname != nil){
		[aCoder encodeObject:self.giftname forKey:kCtGiftname];
	}
	if(self.gifttoken != nil){
		[aCoder encodeObject:self.gifttoken forKey:kCtGifttoken];
	}
	if(self.level != nil){
		[aCoder encodeObject:self.level forKey:kCtLevel];
	}
	if(self.nicename != nil){
		[aCoder encodeObject:self.nicename forKey:kCtNicename];
	}
	[aCoder encodeObject:@(self.showid) forKey:kCtShowid];	[aCoder encodeObject:@(self.totalcoin) forKey:kCtTotalcoin];	[aCoder encodeObject:@(self.touid) forKey:kCtTouid];	if(self.type != nil){
		[aCoder encodeObject:self.type forKey:kCtType];
	}
	[aCoder encodeObject:@(self.uid) forKey:kCtUid];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.action = [aDecoder decodeObjectForKey:kCtAction];
	self.addtime = [[aDecoder decodeObjectForKey:kCtAddtime] integerValue];
	self.avatar = [aDecoder decodeObjectForKey:kCtAvatar];
	self.giftcount = [[aDecoder decodeObjectForKey:kCtGiftcount] integerValue];
	self.gifticon = [aDecoder decodeObjectForKey:kCtGifticon];
	self.giftid = [[aDecoder decodeObjectForKey:kCtGiftid] integerValue];
	self.giftname = [aDecoder decodeObjectForKey:kCtGiftname];
	self.gifttoken = [aDecoder decodeObjectForKey:kCtGifttoken];
	self.level = [aDecoder decodeObjectForKey:kCtLevel];
	self.nicename = [aDecoder decodeObjectForKey:kCtNicename];
	self.showid = [[aDecoder decodeObjectForKey:kCtShowid] integerValue];
	self.totalcoin = [[aDecoder decodeObjectForKey:kCtTotalcoin] integerValue];
	self.touid = [[aDecoder decodeObjectForKey:kCtTouid] integerValue];
	self.type = [aDecoder decodeObjectForKey:kCtType];
	self.uid = [[aDecoder decodeObjectForKey:kCtUid] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Ct *copy = [Ct new];

	copy.action = [self.action copyWithZone:zone];
	copy.addtime = self.addtime;
	copy.avatar = [self.avatar copyWithZone:zone];
	copy.giftcount = self.giftcount;
	copy.gifticon = [self.gifticon copyWithZone:zone];
	copy.giftid = self.giftid;
	copy.giftname = [self.giftname copyWithZone:zone];
	copy.gifttoken = [self.gifttoken copyWithZone:zone];
	copy.level = [self.level copyWithZone:zone];
	copy.nicename = [self.nicename copyWithZone:zone];
	copy.showid = self.showid;
	copy.totalcoin = self.totalcoin;
	copy.touid = self.touid;
	copy.type = [self.type copyWithZone:zone];
	copy.uid = self.uid;

	return copy;
}
@end