//
//	NewEmergingCollectionCellModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NewEmergingCollectionCellModel.h"

NSString *const kNewEmergingCollectionCellModelAvatar = @"avatar";
NSString *const kNewEmergingCollectionCellModelBio = @"bio";
NSString *const kNewEmergingCollectionCellModelName = @"name";
NSString *const kNewEmergingCollectionCellModelUid = @"uid";
NSString *const kNewEmergingCollectionCellModelViews = @"views";

@interface NewEmergingCollectionCellModel ()
@end
@implementation NewEmergingCollectionCellModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
    
    self.liveModel = [[NewLiveModel alloc] initWithDictionary:dictionary];
    
    
	if(![dictionary[kNewEmergingCollectionCellModelAvatar] isKindOfClass:[NSNull class]]){
		self.avatar = dictionary[kNewEmergingCollectionCellModelAvatar];
	}	
	if(![dictionary[kNewEmergingCollectionCellModelBio] isKindOfClass:[NSNull class]]){
		self.bio = dictionary[kNewEmergingCollectionCellModelBio];
	}	
	if(![dictionary[kNewEmergingCollectionCellModelName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kNewEmergingCollectionCellModelName];
	}	
	if(![dictionary[kNewEmergingCollectionCellModelUid] isKindOfClass:[NSNull class]]){
		self.uid = [dictionary[kNewEmergingCollectionCellModelUid] integerValue];
	}

	if(![dictionary[kNewEmergingCollectionCellModelViews] isKindOfClass:[NSNull class]]){
		self.views = [dictionary[kNewEmergingCollectionCellModelViews] integerValue];
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
		dictionary[kNewEmergingCollectionCellModelAvatar] = self.avatar;
	}
	if(self.bio != nil){
		dictionary[kNewEmergingCollectionCellModelBio] = self.bio;
	}
	if(self.name != nil){
		dictionary[kNewEmergingCollectionCellModelName] = self.name;
	}
	dictionary[kNewEmergingCollectionCellModelUid] = @(self.uid);
	dictionary[kNewEmergingCollectionCellModelViews] = @(self.views);
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
		[aCoder encodeObject:self.avatar forKey:kNewEmergingCollectionCellModelAvatar];
	}
	if(self.bio != nil){
		[aCoder encodeObject:self.bio forKey:kNewEmergingCollectionCellModelBio];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kNewEmergingCollectionCellModelName];
	}
	[aCoder encodeObject:@(self.uid) forKey:kNewEmergingCollectionCellModelUid];	[aCoder encodeObject:@(self.views) forKey:kNewEmergingCollectionCellModelViews];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.avatar = [aDecoder decodeObjectForKey:kNewEmergingCollectionCellModelAvatar];
	self.bio = [aDecoder decodeObjectForKey:kNewEmergingCollectionCellModelBio];
	self.name = [aDecoder decodeObjectForKey:kNewEmergingCollectionCellModelName];
	self.uid = [[aDecoder decodeObjectForKey:kNewEmergingCollectionCellModelUid] integerValue];
	self.views = [[aDecoder decodeObjectForKey:kNewEmergingCollectionCellModelViews] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NewEmergingCollectionCellModel *copy = [NewEmergingCollectionCellModel new];

	copy.avatar = [self.avatar copyWithZone:zone];
	copy.bio = [self.bio copyWithZone:zone];
	copy.name = [self.name copyWithZone:zone];
	copy.uid = self.uid;
	copy.views = self.views;

	return copy;
}
@end
