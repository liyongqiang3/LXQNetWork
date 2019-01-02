//
//  TYHttpModelManager.m
//  TYNetWorkDemo
//
//  Created by yongqiang li on 2019/1/2.
//  Copyright © 2019 yongqiang. All rights reserved.
//

#import "TYHttpModelManager.h"
#import <Network/Network.h>

@implementation TYHttpModelManager

- (void)requestPostWithParams:(NSDictionary *)params finished:(void(^)(BOOL suc  ,NSError *error))finished
{
    [self postFromTangyiMobilePath:@"/login/v1/send/sms" withURLParameters:nil bodyParameters:params finished:^(id data, NSInteger status, NSError *error) {
        if (error) {
            if (finished) {
                finished(NO,error);
            }
            return ;
        }
        if (finished) {
            finished(YES,error);
        }
    }];
}

- (void)requestGetWithParams:(NSDictionary *)params finished:(void(^)(BOOL suc, NSError *error))finished
{
    [self requestGetWithParams:params finished:^(BOOL suc, NSError * _Nonnull error) {
        if (error) {
            if (finished) {
                finished(NO,error);
            }
            return ;
        }
        if (finished) {
            finished(YES,error);
        }
    }];
}


@end
