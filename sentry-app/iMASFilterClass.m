//
//  iMASFilterClass.m
//  sentry-app
//
//  Created by Ren, Alice on 8/15/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import "iMASFilterClass.h"
#import "constants.h"
#import <SecureFoundation.h>

@implementation iMASFilterClass

-(id) init  {
    
    self = nil;
    
    return self;
}
+(id) alloc {
    
    return nil;
}

+ (NSMutableArray *)loadFilters {
    static NSMutableArray *filters = nil;
    static dispatch_once_t dToken;
    
    dispatch_once(&dToken, ^{
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"filters.plist"];
        NSData *key = [IMSKeychain passwordDataForService:serviceName account:keyAccountName];
        NSString *orig = [IMSKeychain passwordForService:serviceName account:origSizeAccountName];
        IMSCryptoUtilsDecryptFileToPath([orig intValue], path, nil, key);
        filters = [NSArray arrayWithContentsOfFile:path];
        
        if (filters == nil) filters = [NSMutableArray array];
        
        int newSize  = IMSCryptoUtilsEncryptFileToPath(path, nil, key);
        [IMSKeychain setPassword:[NSString stringWithFormat:@"%d",newSize] forService:serviceName account:origSizeAccountName];
    });
    
    return filters;
}

+ (void)writeFilters:(NSArray *)filters {
    if (!filters) return;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"filters.plist"];
    NSData *key = [IMSKeychain passwordDataForService:serviceName account:keyAccountName];
    
    if (![filters writeToFile:path atomically:YES])
        NSLog(@"failed to write filters to file");
    
    int newSize  = IMSCryptoUtilsEncryptFileToPath(path, nil, key);
    [IMSKeychain setPassword:[NSString stringWithFormat:@"%d",newSize] forService:serviceName account:origSizeAccountName];
}

+ (NSMutableArray *)loadNotifs {
    static NSMutableArray *notifs = nil;
    static dispatch_once_t dToken;
    
    dispatch_once(&dToken, ^{
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"notifs_file"];
        NSData *key = [IMSKeychain passwordDataForService:serviceName account:keyAccountName];
        NSString *orig = [IMSKeychain passwordForService:serviceName account:notifsOrigSizeAccountName];
        IMSCryptoUtilsDecryptFileToPath([orig intValue], path, nil, key);
        notifs = [NSArray arrayWithContentsOfFile:path];
        
        if (notifs == nil) notifs = [NSMutableArray array];
        
        int newSize  = IMSCryptoUtilsEncryptFileToPath(path, nil, key);
        [IMSKeychain setPassword:[NSString stringWithFormat:@"%d",newSize] forService:serviceName account:notifsOrigSizeAccountName];
    });
    
    return notifs;
}

+ (void)writeNotifs:(NSArray *)notifsArray {
    if (!notifsArray) return;
    static dispatch_once_t dToken;
    
    dispatch_once(&dToken, ^{

        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"notifs_file"];
        NSData *key = [IMSKeychain passwordDataForService:serviceName account:keyAccountName];
    
        if (![notifsArray writeToFile:path atomically:YES])
            NSLog(@"failed to write notifications to file");
    
        int newSize  = IMSCryptoUtilsEncryptFileToPath(path, nil, key);
        [IMSKeychain setPassword:[NSString stringWithFormat:@"%d",newSize] forService:serviceName account:notifsOrigSizeAccountName];
    });

}

//Joe
+ (void)retrieveAlerts:(NSString *)alert {
    NSLog(@"%@", alert);
}
@end
