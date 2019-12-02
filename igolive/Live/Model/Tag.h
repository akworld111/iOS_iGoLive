#import <UIKit/UIKit.h>

@interface Tag : NSObject

@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *tag;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;
@end