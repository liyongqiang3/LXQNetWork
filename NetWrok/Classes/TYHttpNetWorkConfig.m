//
//  TYHttpNetWorkConfig.m
//  AFNetworking
//
//  Created by yongqiang li on 2019/1/2.
//

#import "TYHttpNetWorkConfig.h"

@implementation TYHttpNetWorkConfig

+ (instancetype)shareInstance
{
    static TYHttpNetWorkConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TYHttpNetWorkConfig alloc] init];
    });
    return instance;
}

@end
