
//#import "public.h"
NSString * const KAvatar = @"avatar";
NSString * const KBirthday = @"birthday";
NSString * const KCoin = @"coin";
NSString * const KCreate_time = @"create_time";
NSString * const KExpiretime = @"Expiretime";
NSString * const KID = @"id";
NSString * const KSex = @"gender";
NSString * const KToken = @"token";
NSString * const KUser_nicename = @"user_nickname";
NSString * const KUser_type = @"user_type";
NSString * const KSignature = @"signature";
NSString * const  Kcity = @"city";
NSString * const Kconsumption = @"consumption";
NSString * const KisMagic = @"ismagic";
NSString * const KisLive = @"islive";
NSString * const Kisrecommend = @"isrecommend";
NSString * const Kuser_activation_key = @"user_activation_key";
NSString * const Kuser_pass = @"user_pass";
NSString * const Kuser_status = @"user_status";
NSString * const Kmobile = @"mobile";
NSString * const Kwifi = @"wifi";
NSString * const Klevel = @"level";

@implementation Config

#pragma mark - user profile



+ (void)savePersonInfoModel:(PersonalInfoModel *)model {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archive encodeObject:model forKey:@"userInfo"];
    [archive finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+ (PersonalInfoModel *)getpersonInfoModel {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
    NSKeyedUnarchiver *unArchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
      PersonalInfoModel *model = [unArchive decodeObjectForKey:@"userInfo"];
    return model;
}

+ (void)saveProfile:(LiveUser *)user {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:user.avatar forKey:KAvatar];
    [userDefaults setObject:user.birthday forKey:KBirthday];
    [userDefaults setObject:user.coin forKey:KCoin];
    [userDefaults setObject:user.create_time forKey:KCreate_time];
    [userDefaults setObject:user.expiretime forKey:KExpiretime];
    [userDefaults setObject:user.ID forKey:KID];
    [userDefaults setObject:user.gender forKey:KSex];
    [userDefaults setObject:user.token forKey:KToken];
    [userDefaults setObject:user.user_nickname forKey:KUser_nicename];
    [userDefaults setObject:user.user_type forKey:KUser_type];
    [userDefaults setObject:user.signature forKey:KSignature];
    [userDefaults setObject:user.city forKey:Kcity];
    [userDefaults setObject:user.level forKey:Klevel];

    [userDefaults synchronize];
}

+ (void)updateProfile:(LiveUser *)user {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(user.user_nickname != nil) [userDefaults setObject:user.user_nickname forKey:KUser_nicename];
    if(user.signature!=nil) [userDefaults setObject:user.signature forKey:KSignature];
    if(user.avatar!=nil) [userDefaults setObject:user.avatar forKey:KAvatar];
    if(user.city!=nil) [userDefaults setObject:user.city forKey:Kcity];
    if(user.gender!=nil) [userDefaults setObject:user.gender forKey:KSex];
    if(user.coin!=nil) [userDefaults setObject:user.coin forKey:KCoin];
   
    [userDefaults synchronize];
}

+ (void)clearProfile {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nil forKey:KAvatar];
    [userDefaults setObject:nil forKey:KBirthday];
    [userDefaults setObject:nil forKey:KCoin];
    [userDefaults setObject:nil forKey:KCreate_time];
    [userDefaults setObject:nil forKey:KExpiretime];
    [userDefaults setObject:nil forKey:KID];
    [userDefaults setObject:nil forKey:KSex];
    [userDefaults setObject:nil forKey:KToken];
    [userDefaults setObject:nil forKey:KUser_nicename];
    [userDefaults setObject:nil forKey:KUser_type];
    [userDefaults setObject:nil forKey:KSignature];
    [userDefaults setObject:nil forKey:Kcity];
    [userDefaults setObject:nil forKey:KisMagic];
    [userDefaults setObject:nil forKey:Kwifi];
    [userDefaults setObject:nil forKey:Klevel];
    
    [userDefaults synchronize];
}

+ (LiveUser *)myProfile {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    LiveUser *user = [[LiveUser alloc] init];
    user.avatar = [userDefaults objectForKey: KAvatar];
    user.birthday = [userDefaults objectForKey: KBirthday];
    user.coin = [userDefaults objectForKey: KCoin];
    user.create_time = [userDefaults objectForKey: KCreate_time];
    user.expiretime = [userDefaults objectForKey: KExpiretime];
    user.ID = [userDefaults objectForKey: KID];
    user.gender = [userDefaults objectForKey: KSex];
    user.token = [userDefaults objectForKey: KToken];
    user.user_nickname = [userDefaults objectForKey: KUser_nicename];
    user.user_type = [userDefaults objectForKey: KUser_type];
    user.signature = [userDefaults objectForKey:KSignature];
    user.city = [userDefaults objectForKey:Kcity];
    user.level = [userDefaults objectForKey:Klevel];
   
    return user;
    
}

+ (NSString *)getOwnID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ID = [userDefaults objectForKey: KID];
    return ID;
}

+ (NSString *)getOwnNicename {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* nicename = [userDefaults objectForKey: KUser_nicename];
    return nicename;
}

+ (NSString *)getOwnToken {
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefults objectForKey:KToken];
    return token;
}

+ (NSString *)getOwnSignature {
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *signature = [userDefults objectForKey:KSignature];
    return signature;
}

+ (NSString *)getOwnAyatar {
    
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *avatar = [userDefults objectForKey:KAvatar];
    return avatar;
}

+ (NSString *)getOwnWifi {
    
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *wifis = [userDefults objectForKey:Kwifi];
    return wifis;
    
}

+ (NSString *)timeConvert {
    
    NSDate *nowDate = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld",(long)[nowDate timeIntervalSince1970]];
    return dateStr;
}

@end
