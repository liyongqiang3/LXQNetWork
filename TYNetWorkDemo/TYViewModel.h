//
//  TYViewModel.h
//  TYNetWorkDemo
//
//  Created by yongqiang li on 2019/1/2.
//  Copyright © 2019 yongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYViewModel : NSObject

@property (nonatomic, readonly) RACCommand *getCommand;
@property (nonatomic, readonly) RACSignal *getSignal;

@property (nonatomic, readonly) RACCommand *postCommand;
@property (nonatomic, readonly) RACSignal *postSignal;

@property (nonatomic, readonly) RACSignal *errorSignal;

@end

NS_ASSUME_NONNULL_END
