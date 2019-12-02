//
//	SendGiftModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "SendGiftModel.h"

NSString *const kSendGiftModelMethod = @"_method_";
NSString *const kSendGiftModelAction = @"action";
NSString *const kSendGiftModelCity = @"city";
NSString *const kSendGiftModelCt = @"ct";
NSString *const kSendGiftModelEquipment = @"equipment";
NSString *const kSendGiftModelEvensend = @"evensend";
NSString *const kSendGiftModelLevel = @"level";
NSString *const kSendGiftModelMsgtype = @"msgtype";
NSString *const kSendGiftModelRoomnum = @"roomnum";
NSString *const kSendGiftModelSex = @"sex";
NSString *const kSendGiftModelTimestamp = @"timestamp";
NSString *const kSendGiftModelTougood = @"tougood";
NSString *const kSendGiftModelTouid = @"touid";
NSString *const kSendGiftModelTouname = @"touname";
NSString *const kSendGiftModelUgood = @"ugood";
NSString *const kSendGiftModelUhead = @"uhead";
NSString *const kSendGiftModelUid = @"uid";
NSString *const kSendGiftModelUname = @"uname";
NSString *const kSendGiftModelUsign = @"usign";

@interface SendGiftModel ()
@end
@implementation SendGiftModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kSendGiftModelMethod] isKindOfClass:[NSNull class]]){
		self.method = dictionary[kSendGiftModelMethod];
	}	
	if(![dictionary[kSendGiftModelAction] isKindOfClass:[NSNull class]]){
		self.action = dictionary[kSendGiftModelAction];
	}	
	if(![dictionary[kSendGiftModelCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kSendGiftModelCity];
	}	
	if(![dictionary[kSendGiftModelCt] isKindOfClass:[NSNull class]]){
		self.ct = [[Ct alloc] initWithDictionary:dictionary[kSendGiftModelCt]];
	}

	if(![dictionary[kSendGiftModelEquipment] isKindOfClass:[NSNull class]]){
		self.equipment = dictionary[kSendGiftModelEquipment];
	}	
	if(![dictionary[kSendGiftModelEvensend] isKindOfClass:[NSNull class]]){
		self.evensend = dictionary[kSendGiftModelEvensend];
	}	
	if(![dictionary[kSendGiftModelLevel] isKindOfClass:[NSNull class]]){
		self.level = dictionary[kSendGiftModelLevel];
	}	
	if(![dictionary[kSendGiftModelMsgtype] isKindOfClass:[NSNull class]]){
		self.msgtype = dictionary[kSendGiftModelMsgtype];
	}	
	if(![dictionary[kSendGiftModelRoomnum] isKindOfClass:[NSNull class]]){
		self.roomnum = dictionary[kSendGiftModelRoomnum];
	}	
	if(![dictionary[kSendGiftModelSex] isKindOfClass:[NSNull class]]){
		self.sex = dictionary[kSendGiftModelSex];
	}	
	if(![dictionary[kSendGiftModelTimestamp] isKindOfClass:[NSNull class]]){
		self.timestamp = dictionary[kSendGiftModelTimestamp];
	}	
	if(![dictionary[kSendGiftModelTougood] isKindOfClass:[NSNull class]]){
		self.tougood = dictionary[kSendGiftModelTougood];
	}	
	if(![dictionary[kSendGiftModelTouid] isKindOfClass:[NSNull class]]){
		self.touid = dictionary[kSendGiftModelTouid];
	}	
	if(![dictionary[kSendGiftModelTouname] isKindOfClass:[NSNull class]]){
		self.touname = dictionary[kSendGiftModelTouname];
	}	
	if(![dictionary[kSendGiftModelUgood] isKindOfClass:[NSNull class]]){
		self.ugood = dictionary[kSendGiftModelUgood];
	}	
	if(![dictionary[kSendGiftModelUhead] isKindOfClass:[NSNull class]]){
		self.uhead = dictionary[kSendGiftModelUhead];
	}	
	if(![dictionary[kSendGiftModelUid] isKindOfClass:[NSNull class]]){
        
        /* eg_09.30.16 crash fix*/
        // this field when coming from android sending gift, comes over has a number value not a string
        id obj = dictionary[kSendGiftModelUid];
        self.uid = [ObjectTypeValidator nsstringFromObject:obj];
        if (!self.uid)
        {
            NSNumber *nUid = [ObjectTypeValidator SAFEnsnumberIntFromObject:obj];
            self.uid = nUid.stringValue;
        }
        /* _eg */
        
        
        /* legacy */
		//self.uid = dictionary[kSendGiftModelUid];
        /* _legacy */
	}	
	if(![dictionary[kSendGiftModelUname] isKindOfClass:[NSNull class]]){
		self.uname = dictionary[kSendGiftModelUname];
	}	
	if(![dictionary[kSendGiftModelUsign] isKindOfClass:[NSNull class]]){
		self.usign = dictionary[kSendGiftModelUsign];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.method != nil){
		dictionary[kSendGiftModelMethod] = self.method;
	}
	if(self.action != nil){
		dictionary[kSendGiftModelAction] = self.action;
	}
	if(self.city != nil){
		dictionary[kSendGiftModelCity] = self.city;
	}
	if(self.ct != nil){
		dictionary[kSendGiftModelCt] = [self.ct toDictionary];
	}
	if(self.equipment != nil){
		dictionary[kSendGiftModelEquipment] = self.equipment;
	}
	if(self.evensend != nil){
		dictionary[kSendGiftModelEvensend] = self.evensend;
	}
	if(self.level != nil){
		dictionary[kSendGiftModelLevel] = self.level;
	}
	if(self.msgtype != nil){
		dictionary[kSendGiftModelMsgtype] = self.msgtype;
	}
	if(self.roomnum != nil){
		dictionary[kSendGiftModelRoomnum] = self.roomnum;
	}
	if(self.sex != nil){
		dictionary[kSendGiftModelSex] = self.sex;
	}
	if(self.timestamp != nil){
		dictionary[kSendGiftModelTimestamp] = self.timestamp;
	}
	if(self.tougood != nil){
		dictionary[kSendGiftModelTougood] = self.tougood;
	}
	if(self.touid != nil){
		dictionary[kSendGiftModelTouid] = self.touid;
	}
	if(self.touname != nil){
		dictionary[kSendGiftModelTouname] = self.touname;
	}
	if(self.ugood != nil){
		dictionary[kSendGiftModelUgood] = self.ugood;
	}
	if(self.uhead != nil){
		dictionary[kSendGiftModelUhead] = self.uhead;
	}
	if(self.uid != nil){
		dictionary[kSendGiftModelUid] = self.uid;
	}
	if(self.uname != nil){
		dictionary[kSendGiftModelUname] = self.uname;
	}
	if(self.usign != nil){
		dictionary[kSendGiftModelUsign] = self.usign;
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
	if(self.method != nil){
		[aCoder encodeObject:self.method forKey:kSendGiftModelMethod];
	}
	if(self.action != nil){
		[aCoder encodeObject:self.action forKey:kSendGiftModelAction];
	}
	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kSendGiftModelCity];
	}
	if(self.ct != nil){
		[aCoder encodeObject:self.ct forKey:kSendGiftModelCt];
	}
	if(self.equipment != nil){
		[aCoder encodeObject:self.equipment forKey:kSendGiftModelEquipment];
	}
	if(self.evensend != nil){
		[aCoder encodeObject:self.evensend forKey:kSendGiftModelEvensend];
	}
	if(self.level != nil){
		[aCoder encodeObject:self.level forKey:kSendGiftModelLevel];
	}
	if(self.msgtype != nil){
		[aCoder encodeObject:self.msgtype forKey:kSendGiftModelMsgtype];
	}
	if(self.roomnum != nil){
		[aCoder encodeObject:self.roomnum forKey:kSendGiftModelRoomnum];
	}
	if(self.sex != nil){
		[aCoder encodeObject:self.sex forKey:kSendGiftModelSex];
	}
	if(self.timestamp != nil){
		[aCoder encodeObject:self.timestamp forKey:kSendGiftModelTimestamp];
	}
	if(self.tougood != nil){
		[aCoder encodeObject:self.tougood forKey:kSendGiftModelTougood];
	}
	if(self.touid != nil){
		[aCoder encodeObject:self.touid forKey:kSendGiftModelTouid];
	}
	if(self.touname != nil){
		[aCoder encodeObject:self.touname forKey:kSendGiftModelTouname];
	}
	if(self.ugood != nil){
		[aCoder encodeObject:self.ugood forKey:kSendGiftModelUgood];
	}
	if(self.uhead != nil){
		[aCoder encodeObject:self.uhead forKey:kSendGiftModelUhead];
	}
	if(self.uid != nil){
		[aCoder encodeObject:self.uid forKey:kSendGiftModelUid];
	}
	if(self.uname != nil){
		[aCoder encodeObject:self.uname forKey:kSendGiftModelUname];
	}
	if(self.usign != nil){
		[aCoder encodeObject:self.usign forKey:kSendGiftModelUsign];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.method = [aDecoder decodeObjectForKey:kSendGiftModelMethod];
	self.action = [aDecoder decodeObjectForKey:kSendGiftModelAction];
	self.city = [aDecoder decodeObjectForKey:kSendGiftModelCity];
	self.ct = [aDecoder decodeObjectForKey:kSendGiftModelCt];
	self.equipment = [aDecoder decodeObjectForKey:kSendGiftModelEquipment];
	self.evensend = [aDecoder decodeObjectForKey:kSendGiftModelEvensend];
	self.level = [aDecoder decodeObjectForKey:kSendGiftModelLevel];
	self.msgtype = [aDecoder decodeObjectForKey:kSendGiftModelMsgtype];
	self.roomnum = [aDecoder decodeObjectForKey:kSendGiftModelRoomnum];
	self.sex = [aDecoder decodeObjectForKey:kSendGiftModelSex];
	self.timestamp = [aDecoder decodeObjectForKey:kSendGiftModelTimestamp];
	self.tougood = [aDecoder decodeObjectForKey:kSendGiftModelTougood];
	self.touid = [aDecoder decodeObjectForKey:kSendGiftModelTouid];
	self.touname = [aDecoder decodeObjectForKey:kSendGiftModelTouname];
	self.ugood = [aDecoder decodeObjectForKey:kSendGiftModelUgood];
	self.uhead = [aDecoder decodeObjectForKey:kSendGiftModelUhead];
	self.uid = [aDecoder decodeObjectForKey:kSendGiftModelUid];
	self.uname = [aDecoder decodeObjectForKey:kSendGiftModelUname];
	self.usign = [aDecoder decodeObjectForKey:kSendGiftModelUsign];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
//- (instancetype)copyWithZone:(NSZone *)zone
//{
//	SendGiftModel *copy = [SendGiftModel new];
//
//	copy.method = [self.method copyWithZone:zone];
//	copy.action = [self.action copyWithZone:zone];
//	copy.city = [self.city copyWithZone:zone];
//	copy.ct = [self.ct copyWithZone:zone];
//	copy.equipment = [self.equipment copyWithZone:zone];
//	copy.evensend = [self.evensend copyWithZone:zone];
//	copy.level = [self.level copyWithZone:zone];
//	copy.msgtype = [self.msgtype copyWithZone:zone];
//	copy.roomnum = [self.roomnum copyWithZone:zone];
//	copy.sex = [self.sex copyWithZone:zone];
//	copy.timestamp = [self.timestamp copyWithZone:zone];
//	copy.tougood = [self.tougood copyWithZone:zone];
//	copy.touid = [self.touid copyWithZone:zone];
//	copy.touname = [self.touname copyWithZone:zone];
//	copy.ugood = [self.ugood copyWithZone:zone];
//	copy.uhead = [self.uhead copyWithZone:zone];
//	copy.uid = [self.uid copyWithZone:zone];
//	copy.uname = [self.uname copyWithZone:zone];
//	copy.usign = [self.usign copyWithZone:zone];
//
//	return copy;
//}
@end
