//
//  TYHttpSessionManager.h
//  SVideo
//
//  Created by yongqiang li on 2018/11/28.
//  Copyright © 2018 Bitstarlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYHttpSessionManager : AFHTTPSessionManager

+ (instancetype)manager;

+ (instancetype)postManager;

@end

NS_ASSUME_NONNULL_END
