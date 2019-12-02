//
//	NewLiveModel.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NewLiveModel.h"

NSString *const kNewLiveModelAddress = @"address";
NSString *const kNewLiveModelAvatar = @"avatar";
NSString *const kNewLiveModelCity = @"city";
NSString *const kNewLiveModelEndtime = @"endtime";
NSString *const kNewLiveModelGender = @"gender";
NSString *const kNewLiveModelIdField = @"id";
NSString *const kNewLiveModelIslive = @"islive";
NSString *const kNewLiveModelLevel = @"level";
NSString *const kNewLiveModelLight = @"light";
NSString *const kNewLiveModelNums = @"nums";
NSString *const kNewLiveModelProvince = @"province";
NSString *const kNewLiveModelShowid = @"showid";
NSString *const kNewLiveModelStarttime = @"starttime";
NSString *const kNewLiveModelTags = @"tags";
NSString *const kNewLiveModelTitle = @"title";
NSString *const kNewLiveModelUid = @"uid";
NSString *const kNewLiveModelUserNickname = @"user_nickname";

// new
NSString *const kNewLiveModelUserName = @"name";

NSString *const kNewLiveModelViewsField = @"views";
NSString *const kNewLiveModelStarsField = @"stars";
NSString *const kNewLiveModelBioField = @"bio";

@interface NewLiveModel ()
@end
@implementation NewLiveModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNewLiveModelAddress] isKindOfClass:[NSNull class]]){
		self.address = dictionary[kNewLiveModelAddress];
	}	
	if(![dictionary[kNewLiveModelAvatar] isKindOfClass:[NSNull class]]){
		self.avatar = dictionary[kNewLiveModelAvatar];
	}	
	if(![dictionary[kNewLiveModelCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kNewLiveModelCity];
	}	
	if(![dictionary[kNewLiveModelEndtime] isKindOfClass:[NSNull class]]){
		self.endtime = dictionary[kNewLiveModelEndtime];
	}	
	if(![dictionary[kNewLiveModelGender] isKindOfClass:[NSNull class]]){
		self.gender = dictionary[kNewLiveModelGender];
	}	
	if(![dictionary[kNewLiveModelIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kNewLiveModelIdField];
	}
	if(![dictionary[kNewLiveModelIslive] isKindOfClass:[NSNull class]]){
		self.islive = dictionary[kNewLiveModelIslive];
	}	
	if(![dictionary[kNewLiveModelLevel] isKindOfClass:[NSNull class]]){
		self.level = dictionary[kNewLiveModelLevel];
	}	
	if(![dictionary[kNewLiveModelLight] isKindOfClass:[NSNull class]]){
		self.light = dictionary[kNewLiveModelLight];
	}	
	if(![dictionary[kNewLiveModelNums] isKindOfClass:[NSNull class]]){
		self.nums = dictionary[kNewLiveModelNums];
	}	
	if(![dictionary[kNewLiveModelProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kNewLiveModelProvince];
	}	
	if(![dictionary[kNewLiveModelShowid] isKindOfClass:[NSNull class]]){
		self.showid = dictionary[kNewLiveModelShowid];
	}	
	if(![dictionary[kNewLiveModelStarttime] isKindOfClass:[NSNull class]]){
		self.starttime = dictionary[kNewLiveModelStarttime];
	}	
	if(![dictionary[kNewLiveModelTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kNewLiveModelTags];
	}	
	if(![dictionary[kNewLiveModelTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kNewLiveModelTitle];
	}	
	if(![dictionary[kNewLiveModelUid] isKindOfClass:[NSNull class]]){
		self.uid = dictionary[kNewLiveModelUid];
        if (!self.idField)
        {
            // new 1 of 5
            self.idField = [NSString stringWithString:self.uid]; // support LookLiveStreamVC coming from NewMergingCell
        }
	}
	if(![dictionary[kNewLiveModelUserNickname] isKindOfClass:[NSNull class]]){
		self.userNickname = dictionary[kNewLiveModelUserNickname];
    }
    if(![dictionary[kNewLiveModelUserName] isKindOfClass:[NSNull class]]){
        //XLM_warning(@"legacy field: '%@' not found, but new field: '%@' indeed found in dict model (return json maybe)\n SETTING '%@' with this instead", kNewLiveModelUserNickname, kNewLiveModelUserName, @"self.userNickname");
        
        // new 2 of 5
        if (!self.userNickname) {
            self.userNickname = dictionary[kNewLiveModelUserName]; // support LookLiveStreamVC coming from NewMergingCell
        }
    }
    
    // new 3 or 5
    if(![dictionary[kNewLiveModelViewsField] isKindOfClass:[NSNull class]]){
        self.views = dictionary[kNewLiveModelViewsField]; // support LookLiveStreamVC coming from NewMergingCell
    }
    if(![dictionary[kNewLiveModelStarsField] isKindOfClass:[NSNull class]]){
        self.stars = dictionary[kNewLiveModelStarsField]; // support LookLiveStreamVC coming from NewMergingCell
    }
    if(![dictionary[kNewLiveModelBioField] isKindOfClass:[NSNull class]]){
        self.bio = dictionary[kNewLiveModelBioField]; // support LookLiveStreamVC coming from NewMergingCell
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
		dictionary[kNewLiveModelAddress] = self.address;
	}
	if(self.avatar != nil){
		dictionary[kNewLiveModelAvatar] = self.avatar;
	}
	if(self.city != nil){
		dictionary[kNewLiveModelCity] = self.city;
	}
	if(self.endtime != nil){
		dictionary[kNewLiveModelEndtime] = self.endtime;
	}
	if(self.gender != nil){
		dictionary[kNewLiveModelGender] = self.gender;
	}
	if(self.idField != nil){
		dictionary[kNewLiveModelIdField] = self.idField;
	}
	if(self.islive != nil){
		dictionary[kNewLiveModelIslive] = self.islive;
	}
	if(self.level != nil){
		dictionary[kNewLiveModelLevel] = self.level;
	}
	if(self.light != nil){
		dictionary[kNewLiveModelLight] = self.light;
	}
	if(self.nums != nil){
		dictionary[kNewLiveModelNums] = self.nums;
	}
	if(self.province != nil){
		dictionary[kNewLiveModelProvince] = self.province;
	}
	if(self.showid != nil){
		dictionary[kNewLiveModelShowid] = self.showid;
	}
	if(self.starttime != nil){
		dictionary[kNewLiveModelStarttime] = self.starttime;
	}
	if(self.tags != nil){
		dictionary[kNewLiveModelTags] = self.tags;
	}
	if(self.title != nil){
		dictionary[kNewLiveModelTitle] = self.title;
	}
	if(self.uid != nil){
		dictionary[kNewLiveModelUid] = self.uid;
	}
	if(self.userNickname != nil){
		dictionary[kNewLiveModelUserNickname] = self.userNickname;
        dictionary[kNewLiveModelUserName] = self.userNickname; // support LookLiveStreamVC coming from NewMergingCell
    }
    
    if(self.views != nil){
        dictionary[kNewLiveModelViewsField] = self.views; // support LookLiveStreamVC coming from NewMergingCell
    }
    if(self.stars != nil){
        dictionary[kNewLiveModelStarsField] = self.stars; // support LookLiveStreamVC coming from NewMergingCell
    }
    if(self.bio != nil){
        dictionary[kNewLiveModelBioField] = self.bio; // support LookLiveStreamVC coming from NewMergingCell
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
		[aCoder encodeObject:self.address forKey:kNewLiveModelAddress];
	}
	if(self.avatar != nil){
		[aCoder encodeObject:self.avatar forKey:kNewLiveModelAvatar];
	}
	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kNewLiveModelCity];
	}
	if(self.endtime != nil){
		[aCoder encodeObject:self.endtime forKey:kNewLiveModelEndtime];
	}
	if(self.gender != nil){
		[aCoder encodeObject:self.gender forKey:kNewLiveModelGender];
	}
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kNewLiveModelIdField];
	}
	if(self.islive != nil){
		[aCoder encodeObject:self.islive forKey:kNewLiveModelIslive];
	}
	if(self.level != nil){
		[aCoder encodeObject:self.level forKey:kNewLiveModelLevel];
	}
	if(self.light != nil){
		[aCoder encodeObject:self.light forKey:kNewLiveModelLight];
	}
	if(self.nums != nil){
		[aCoder encodeObject:self.nums forKey:kNewLiveModelNums];
	}
	if(self.province != nil){
		[aCoder encodeObject:self.province forKey:kNewLiveModelProvince];
	}
	if(self.showid != nil){
		[aCoder encodeObject:self.showid forKey:kNewLiveModelShowid];
	}
	if(self.starttime != nil){
		[aCoder encodeObject:self.starttime forKey:kNewLiveModelStarttime];
	}
	if(self.tags != nil){
		[aCoder encodeObject:self.tags forKey:kNewLiveModelTags];
	}
	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kNewLiveModelTitle];
	}
	if(self.uid != nil){
		[aCoder encodeObject:self.uid forKey:kNewLiveModelUid];
	}
	if(self.userNickname != nil){
		[aCoder encodeObject:self.userNickname forKey:kNewLiveModelUserNickname];
        [aCoder encodeObject:self.userNickname forKey:kNewLiveModelUserName]; // support LookLiveStreamVC coming from NewMergingCell
	}
    
    if(self.views != nil){
        [aCoder encodeObject:self.views forKey:kNewLiveModelViewsField]; // support LookLiveStreamVC coming from NewMergingCell
    }
    if(self.stars != nil){
        [aCoder encodeObject:self.stars forKey:kNewLiveModelStarsField]; // support LookLiveStreamVC coming from NewMergingCell
    }
    if(self.bio != nil){
        [aCoder encodeObject:self.bio forKey:kNewLiveModelBioField]; // support LookLiveStreamVC coming from NewMergingCell
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.address = [aDecoder decodeObjectForKey:kNewLiveModelAddress];
	self.avatar = [aDecoder decodeObjectForKey:kNewLiveModelAvatar];
	self.city = [aDecoder decodeObjectForKey:kNewLiveModelCity];
	self.endtime = [aDecoder decodeObjectForKey:kNewLiveModelEndtime];
	self.gender = [aDecoder decodeObjectForKey:kNewLiveModelGender];
	self.idField = [aDecoder decodeObjectForKey:kNewLiveModelIdField];
	self.islive = [aDecoder decodeObjectForKey:kNewLiveModelIslive];
	self.level = [aDecoder decodeObjectForKey:kNewLiveModelLevel];
	self.light = [aDecoder decodeObjectForKey:kNewLiveModelLight];
	self.nums = [aDecoder decodeObjectForKey:kNewLiveModelNums];
	self.province = [aDecoder decodeObjectForKey:kNewLiveModelProvince];
	self.showid = [aDecoder decodeObjectForKey:kNewLiveModelShowid];
	self.starttime = [aDecoder decodeObjectForKey:kNewLiveModelStarttime];
	self.tags = [aDecoder decodeObjectForKey:kNewLiveModelTags];
	self.title = [aDecoder decodeObjectForKey:kNewLiveModelTitle];
	self.uid = [aDecoder decodeObjectForKey:kNewLiveModelUid];
	self.userNickname = [aDecoder decodeObjectForKey:kNewLiveModelUserNickname];
    if (!self.userNickname)
    {
        self.userNickname = [aDecoder decodeObjectForKey:kNewLiveModelUserName]; // support LookLiveStreamVC coming from NewMergingCell
    }
    
    self.views = [aDecoder decodeObjectForKey:kNewLiveModelViewsField]; // support LookLiveStreamVC coming from NewMergingCell
    self.stars = [aDecoder decodeObjectForKey:kNewLiveModelStarsField]; // support LookLiveStreamVC coming from NewMergingCell
    self.bio = [aDecoder decodeObjectForKey:kNewLiveModelBioField]; // support LookLiveStreamVC coming from NewMergingCell
    
	return self;
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NewLiveModel *copy = [NewLiveModel new];

	copy.address = [self.address copyWithZone:zone];
	copy.avatar = [self.avatar copyWithZone:zone];
	copy.city = [self.city copyWithZone:zone];
	copy.endtime = [self.endtime copyWithZone:zone];
	copy.gender = [self.gender copyWithZone:zone];
	copy.idField = [self.idField copyWithZone:zone];
	copy.islive = [self.islive copyWithZone:zone];
	copy.level = [self.level copyWithZone:zone];
	copy.light = [self.light copyWithZone:zone];
	copy.nums = [self.nums copyWithZone:zone];
	copy.province = [self.province copyWithZone:zone];
	copy.showid = [self.showid copyWithZone:zone];
	copy.starttime = [self.starttime copyWithZone:zone];
	copy.tags = [self.tags copyWithZone:zone];
	copy.title = [self.title copyWithZone:zone];
	copy.uid = [self.uid copyWithZone:zone];
	copy.userNickname = [self.userNickname copyWithZone:zone];
    
    copy.views = [self.views copyWithZone:zone]; // support LookLiveStreamVC coming from NewMergingCell
    copy.stars = [self.stars copyWithZone:zone]; // support LookLiveStreamVC coming from NewMergingCell
    copy.bio = [self.bio copyWithZone:zone]; // support LookLiveStreamVC coming from NewMergingCell

	return copy;
}


@end


