//
//	FollowModel.h
//
//	Create by sdd on 19/8/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface FollowModel : NSObject

@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * experience;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger isattention;
@property (nonatomic, strong) NSString * isrecommend;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, strong) NSString * stars;
@property (nonatomic, strong) NSString * starsTotal;
@property (nonatomic, strong) NSString * userNickname;
@property (nonatomic, strong) NSString * votes;
@property (nonatomic, strong) NSString * votestotal;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end