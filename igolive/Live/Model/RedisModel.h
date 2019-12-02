#import <UIKit/UIKit.h>

@interface RedisModel : NSObject

@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * coin;
@property (nonatomic, strong) NSString * experience;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger islive;
@property (nonatomic, strong) NSString * isrecommend;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * sign;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, strong) NSString * stars;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, strong) NSString * userNickname;
@property (nonatomic, strong) NSString * votes;
@property (nonatomic, strong) NSString * votestotal;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end