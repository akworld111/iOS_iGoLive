#import <UIKit/UIKit.h>

@interface RecordedListModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * datetime;
@property (nonatomic, strong) NSString * endtime;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * islive;
@property (nonatomic, strong) NSString * light;
@property (nonatomic, strong) NSString * nums;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * showid;
@property (nonatomic, strong) NSString * starttime;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * uid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end