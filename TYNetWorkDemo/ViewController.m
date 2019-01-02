//
//  ViewController.m
//  TYNetWork
//
//  Created by yongqiang li on 2019/1/2.
//  Copyright © 2019 yongqiang. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TYViewModel.h"


@interface ViewController ()

@property (nonatomic,strong) UIButton *postButton;
@property (nonatomic,strong) UIButton *getButton;
@property (nonatomic,strong) TYViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self bindingEvent];
}

- (void)setupUI
{
    [self.view addSubview:self.getButton];
    [self.view addSubview:self.postButton];
}

- (void)bindingEvent
{
    [self.viewModel.postSignal subscribeNext:^(NSNumber *value) {
        NSLog(@"post  suc ===%@",value);
    }];
    [self.viewModel.getSignal subscribeNext:^(NSNumber *next) {
        NSLog(@"get  suc ===%@",next);
    }];
    [self.viewModel.errorSignal subscribeNext:^(NSError *error) {
        NSLog(@"errorSignal ===%@",error);
    }];
}

- (TYViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[TYViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)postButton
{
    if (!_postButton) {
        _postButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 150, 40)];
        _postButton.backgroundColor = [UIColor grayColor];
        [_postButton setTitle:@"post" forState:UIControlStateNormal];
        [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postButton addTarget:self action:@selector(onClickPostButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postButton;
}

- (void)onClickPostButtonEvent
{
    [self.viewModel.postCommand execute:@{@"phone":@"18911697243"}];
}

- (UIButton *)getButton
{
    if (!_getButton) {
        _getButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 150, 40)];
        _getButton.backgroundColor = [UIColor grayColor];
        [_getButton setTitle:@"get" forState:UIControlStateNormal];
        [_getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postButton addTarget:self action:@selector(onClickGetButtonEvent) forControlEvents:UIControlEventTouchUpInside];

    }
    return _getButton;
}

- (void)onClickGetButtonEvent
{
    [self.viewModel.postCommand execute:nil];
}


@end
