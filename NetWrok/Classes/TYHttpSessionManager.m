//
//  TYHttpSessionManager.m
//  SVideo
//
//  Created by yongqiang li on 2018/11/28.
//  Copyright © 2018 Bitstarlight. All rights reserved.
//

#import "TYHttpSessionManager.h"

@implementation TYHttpSessionManager

+ (instancetype)manager
{
    static TYHttpSessionManager *managerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerInstance = [[TYHttpSessionManager alloc] init];
        managerInstance.requestSerializer = [AFHTTPRequestSerializer serializer];
    });
    return managerInstance;
}

+ (instancetype)postManager
{
    static TYHttpSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TYHttpSessionManager alloc] init];
        instance.requestSerializer = [AFHTTPRequestSerializer serializer];
        [instance.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
        [instance.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    });
    return instance;
}
@end
