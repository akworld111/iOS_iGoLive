//
//	LevelModel.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "LevelModel.h"

NSString *const kLevelModelExperience = @"experience";
NSString *const kLevelModelLevelRate = @"level_rate";
NSString *const kLevelModelLevelid = @"levelid";

@interface LevelModel ()
@end
@implementation LevelModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kLevelModelExperience] isKindOfClass:[NSNull class]]){
		self.experience = dictionary[kLevelModelExperience];
	}	
	if(![dictionary[kLevelModelLevelRate] isKindOfClass:[NSNull class]]){
		self.levelRate = [dictionary[kLevelModelLevelRate] integerValue];
	}

	if(![dictionary[kLevelModelLevelid] isKindOfClass:[NSNull class]]){
		self.levelid = dictionary[kLevelModelLevelid];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.experience != nil){
		dictionary[kLevelModelExperience] = self.experience;
	}
	dictionary[kLevelModelLevelRate] = @(self.levelRate);
	if(self.levelid != nil){
		dictionary[kLevelModelLevelid] = self.levelid;
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
	if(self.experience != nil){
		[aCoder encodeObject:self.experience forKey:kLevelModelExperience];
	}
	[aCoder encodeObject:@(self.levelRate) forKey:kLevelModelLevelRate];	if(self.levelid != nil){
		[aCoder encodeObject:self.levelid forKey:kLevelModelLevelid];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.experience = [aDecoder decodeObjectForKey:kLevelModelExperience];
	self.levelRate = [[aDecoder decodeObjectForKey:kLevelModelLevelRate] integerValue];
	self.levelid = [aDecoder decodeObjectForKey:kLevelModelLevelid];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	LevelModel *copy = [LevelModel new];

	copy.experience = [self.experience copyWithZone:zone];
	copy.levelRate = self.levelRate;
	copy.levelid = [self.levelid copyWithZone:zone];

	return copy;
}
@end