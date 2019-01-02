//
//  TYHttpNetWorkConfig.h
//  AFNetworking
//
//  Created by yongqiang li on 2019/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYHttpNetWorkConfig : NSObject

@property (nonatomic, copy) NSString *baseUrl; // 请求 的URL

@property (nonatomic, copy) NSDictionary *baseParams; // 请求的基础参数


+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
