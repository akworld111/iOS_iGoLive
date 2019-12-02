//
//	PersonalInfoModel.h
//
//	Create by sdd on 30/8/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "InterestModel.h"
#import "CoinRecordModel.h"

@interface PersonalInfoModel : NSObject

@property (nonatomic, assign) NSInteger attentionnum;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * coin;
@property (nonatomic, strong) NSArray * coinrecord3;
@property (nonatomic, strong) NSString * consumption;
@property (nonatomic, strong) NSString * experience;
@property (nonatomic, assign) NSInteger fansnum;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSArray * interests;
@property (nonatomic, strong) NSString * isrecommend;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger liverecordnum;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, strong) NSString * stars;
@property (nonatomic, strong) NSString * starsTotal;
@property (nonatomic, strong) NSString * userNickname;
@property (nonatomic, strong) NSString * votes;
@property (nonatomic, strong) NSString * votestotal;

/**
 *  eg: NOTE_09.06.16: added self.coinRecordFan1, self.coinRecordFan2, self.coinRecordFan3
 *                  parsing from self.coinrecord3
 *      not included in:
 *          toDictionary
 *          encodeWithCoder:
 *          initWithCoder:
 *          copyWithZone:
 */
@property (nonatomic, retain) CoinRecordModel *coinRecordFan1;
@property (nonatomic, retain) CoinRecordModel *coinRecordFan2;
@property (nonatomic, retain) CoinRecordModel *coinRecordFan3;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end