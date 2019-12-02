//
//	Tag.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Tag.h"

NSString *const kTagChannelId = @"channel_id";
NSString *const kTagIdField = @"id";
NSString *const kTagTag = @"tag";

@interface Tag ()
@end
@implementation Tag


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];

	if (![dictionary[kTagChannelId] isKindOfClass:[NSNull class]]) {
		self.channelId = dictionary[kTagChannelId];
	}	
	if (![dictionary[kTagIdField] isKindOfClass:[NSNull class]]) {
		self.idField = dictionary[kTagIdField];
	}	
	if (![dictionary[kTagTag] isKindOfClass:[NSNull class]]) {
		self.tag = dictionary[kTagTag];
	}	
	return self;
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

	if (self.channelId != nil) {
		dictionary[kTagChannelId] = self.channelId;
	}
	if (self.idField != nil) {
		dictionary[kTagIdField] = self.idField;
	}
	if (self.tag != nil) {
		dictionary[kTagTag] = self.tag;
	}

	return dictionary;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	if (self.channelId != nil) {
		[aCoder encodeObject:self.channelId forKey:kTagChannelId];
	}
	if (self.idField != nil) {
		[aCoder encodeObject:self.idField forKey:kTagIdField];
	}
	if (self.tag != nil) {
		[aCoder encodeObject:self.tag forKey:kTagTag];
	}

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];

	self.channelId = [aDecoder decodeObjectForKey:kTagChannelId];
	self.idField = [aDecoder decodeObjectForKey:kTagIdField];
	self.tag = [aDecoder decodeObjectForKey:kTagTag];

	return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
	Tag *copy = [Tag new];

	copy.channelId = [self.channelId copyWithZone:zone];
	copy.idField = [self.idField copyWithZone:zone];
	copy.tag = [self.tag copyWithZone:zone];

	return copy;
}
@end