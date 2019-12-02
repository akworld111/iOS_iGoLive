//
//	LiveChannelsModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "LiveChannelsModel.h"

NSString *const kLiveChannelsModelChannelName = @"channel_name";
NSString *const kLiveChannelsModelColor = @"color";
NSString *const kLiveChannelsModelIdField = @"id";
NSString *const kLiveChannelsModelIsSpecial = @"is_special";
NSString *const kLiveChannelsModelStreamCount = @"stream_count";
NSString *const kLiveChannelsModelTags = @"tags";

@interface LiveChannelsModel ()
@end
@implementation LiveChannelsModel


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];

	if (![dictionary[kLiveChannelsModelChannelName] isKindOfClass:[NSNull class]]) {
		self.channelName = dictionary[kLiveChannelsModelChannelName];
	}	
	if (![dictionary[kLiveChannelsModelColor] isKindOfClass:[NSNull class]]) {
		self.color = dictionary[kLiveChannelsModelColor];
	}	
	if (![dictionary[kLiveChannelsModelIdField] isKindOfClass:[NSNull class]]) {
		self.idField = dictionary[kLiveChannelsModelIdField];
	}	
	if (![dictionary[kLiveChannelsModelIsSpecial] isKindOfClass:[NSNull class]]) {
		self.isSpecial = dictionary[kLiveChannelsModelIsSpecial];
	}	
	if (![dictionary[kLiveChannelsModelStreamCount] isKindOfClass:[NSNull class]]) {
		self.streamCount = [dictionary[kLiveChannelsModelStreamCount] integerValue];
	}

	if (dictionary[kLiveChannelsModelTags] != nil && [dictionary[kLiveChannelsModelTags] isKindOfClass:[NSArray class]]) {
		NSArray *tagsDictionaries = dictionary[kLiveChannelsModelTags];
		NSMutableArray *tagsItems = [NSMutableArray array];
		for(NSDictionary *tagsDictionary in tagsDictionaries) {
			Tag *tagsItem = [[Tag alloc] initWithDictionary:tagsDictionary];
			[tagsItems addObject:tagsItem];
		}
		self.tags = tagsItems;
	}
	return self;
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

	if (self.channelName != nil) {
		dictionary[kLiveChannelsModelChannelName] = self.channelName;
	}
	if (self.color != nil) {
		dictionary[kLiveChannelsModelColor] = self.color;
	}
	if (self.idField != nil) {
		dictionary[kLiveChannelsModelIdField] = self.idField;
	}
	if (self.isSpecial != nil) {
		dictionary[kLiveChannelsModelIsSpecial] = self.isSpecial;
	}
	dictionary[kLiveChannelsModelStreamCount] = @(self.streamCount);
	if (self.tags != nil) {
		NSMutableArray *dictionaryElements = [NSMutableArray array];
		for(Tag *tagsElement in self.tags) {
			[dictionaryElements addObject:[tagsElement toDictionary]];
		}
		dictionary[kLiveChannelsModelTags] = dictionaryElements;
	}

	return dictionary;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	if (self.channelName != nil) {
		[aCoder encodeObject:self.channelName forKey:kLiveChannelsModelChannelName];
	}
	if (self.color != nil) {
		[aCoder encodeObject:self.color forKey:kLiveChannelsModelColor];
	}
	if (self.idField != nil) {
		[aCoder encodeObject:self.idField forKey:kLiveChannelsModelIdField];
	}
	if (self.isSpecial != nil) {
		[aCoder encodeObject:self.isSpecial forKey:kLiveChannelsModelIsSpecial];
	}
	[aCoder encodeObject:@(self.streamCount) forKey:kLiveChannelsModelStreamCount];	if (self.tags != nil) {
		[aCoder encodeObject:self.tags forKey:kLiveChannelsModelTags];
	}

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];

	self.channelName = [aDecoder decodeObjectForKey:kLiveChannelsModelChannelName];
	self.color = [aDecoder decodeObjectForKey:kLiveChannelsModelColor];
	self.idField = [aDecoder decodeObjectForKey:kLiveChannelsModelIdField];
	self.isSpecial = [aDecoder decodeObjectForKey:kLiveChannelsModelIsSpecial];
	self.streamCount = [[aDecoder decodeObjectForKey:kLiveChannelsModelStreamCount] integerValue];
	self.tags = [aDecoder decodeObjectForKey:kLiveChannelsModelTags];

	return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
	LiveChannelsModel *copy = [LiveChannelsModel new];

	copy.channelName = [self.channelName copyWithZone:zone];
	copy.color = [self.color copyWithZone:zone];
	copy.idField = [self.idField copyWithZone:zone];
	copy.isSpecial = [self.isSpecial copyWithZone:zone];
	copy.streamCount = self.streamCount;
	copy.tags = [self.tags copyWithZone:zone];

	return copy;
}
@end