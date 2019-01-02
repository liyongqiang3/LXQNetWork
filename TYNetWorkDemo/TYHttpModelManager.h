//
//  TYHttpModelManager.h
//  TYNetWorkDemo
//
//  Created by yongqiang li on 2019/1/2.
//  Copyright © 2019 yongqiang. All rights reserved.
//

#import "TYBaseModelManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYHttpModelManager : TYBaseModelManager

- (void)requestPostWithParams:(NSDictionary *)params finished:(void(^)(BOOL suc  ,NSError *error))finished;

- (void)requestGetWithParams:(NSDictionary *)params finished:(void(^)(BOOL suc  ,NSError *error))finished;


@end

NS_ASSUME_NONNULL_END
