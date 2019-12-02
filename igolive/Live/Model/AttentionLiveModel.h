#import <UIKit/UIKit.h>

@interface AttentionLiveModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * endtime;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * islive;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * light;
@property (nonatomic, strong) NSString * nums;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * showid;
@property (nonatomic, strong) NSString * starttime;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * userNickname;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end