#import <UIKit/UIKit.h>
#import "Tag.h"

@interface LiveChannelsModel : NSObject

@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *isSpecial;
@property (nonatomic, assign) NSInteger streamCount;
@property (nonatomic, strong) NSArray<Tag *> *tags;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;
@end
