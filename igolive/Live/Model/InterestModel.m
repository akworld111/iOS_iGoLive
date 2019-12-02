//
//	InterestModel.m
//
//	Create by sdd on 26/8/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "InterestModel.h"

NSString *const kInterestModelIdField = @"id";
NSString *const kInterestModelName = @"name";

@interface InterestModel ()
@end
@implementation InterestModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kInterestModelIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kInterestModelIdField];
	}	
	if(![dictionary[kInterestModelName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kInterestModelName];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.idField != nil){
		dictionary[kInterestModelIdField] = self.idField;
	}
	if(self.name != nil){
		dictionary[kInterestModelName] = self.name;
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
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kInterestModelIdField];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kInterestModelName];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.idField = [aDecoder decodeObjectForKey:kInterestModelIdField];
	self.name = [aDecoder decodeObjectForKey:kInterestModelName];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	InterestModel *copy = [InterestModel new];

	copy.idField = [self.idField copyWithZone:zone];
	copy.name = [self.name copyWithZone:zone];

	return copy;
}
@end