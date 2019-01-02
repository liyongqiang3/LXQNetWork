//
//  TYViewModel.m
//  TYNetWorkDemo
//
//  Created by yongqiang li on 2019/1/2.
//  Copyright © 2019 yongqiang. All rights reserved.
//

#import "TYViewModel.h"
#import <Network/Network.h>
#import "TYHttpModelManager.h"

@interface TYViewModel()

@property (nonatomic) RACCommand *getCommand;
@property (nonatomic) RACSignal *getSignal;

@property (nonatomic) RACCommand *postCommand;
@property (nonatomic) RACSignal *postSignal;

@property (nonatomic) RACSignal *errorSignal;
@property (nonatomic) TYHttpModelManager *httpModelManager;

@end

@implementation TYViewModel

- (id)init

{
    self = [super init];
    if (self) {
        _getSignal = [[self.getCommand.executionSignals flattenMap:^__kindof RACSignal * _Nullable(RACSignal   *signal) {
            return signal;
        }]deliverOnMainThread];
        
        _postSignal = [[self.postCommand.executionSignals flattenMap:^__kindof RACSignal * _Nullable(RACSignal  *signal) {
            return signal;
        }] deliverOnMainThread];
        
        _errorSignal = [[self.getCommand.errors merge:self.postCommand.errors] deliverOnMainThread];
    }
    return self;
}

- (RACCommand *)postCommand
{
    if (!_postCommand) {
        @weakify(self);
        _postCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *params) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self.httpModelManager requestPostWithParams:params finished:^(BOOL suc, NSError * _Nonnull error) {
                    if (error) {
                        [subscriber sendError:error];
                        return ;
                    }
                    [subscriber sendNext:@(suc)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _postCommand;
}


- (RACCommand *)getCommand
{
    if (!_getCommand) {
        @weakify(self);
        _getCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *params) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self.httpModelManager  requestGetWithParams:params finished:^(BOOL suc, NSError * _Nonnull error) {
                    if (error) {
                        [subscriber sendError:error];
                        return ;
                    }
                    [subscriber sendNext:@(suc)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _getCommand;
}


- (TYHttpModelManager *)httpModelManager
{
    if (!_httpModelManager) {
        _httpModelManager = [[TYHttpModelManager alloc] init];
    }
    return _httpModelManager;
}

@end
