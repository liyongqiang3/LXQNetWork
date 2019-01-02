//
//  TYDefined.h
//  TYVideoPlayerDemo
//
//  Created by yongqiang li on 2018/9/18.
//  Copyright © 2018 yongqiang. All rights reserved.
//

#ifndef TYDefined_h
#define TYDefined_h

// 调用 block之前 要判断是否nil
#define safeFinish(block,...)\
do { \
if (block) { \
block(__VA_ARGS__); \
} \
} while (0)

//异步插入主线
#define within_main_thread(block,...) \
try {} @finally {} \
do { \
if ([[NSThread currentThread] isMainThread]) { \
if (block) { \
block(__VA_ARGS__); \
} \
} else { \
if (block) { \
dispatch_async(dispatch_get_main_queue(), ^(){ \
block(__VA_ARGS__); \
}); \
} \
} \
} while(0)

//同步主线程
#define within_main_thread_sync(block,...) \
try {} @finally {} \
do { \
if ([[NSThread currentThread] isMainThread]) { \
if (block) { \
block(__VA_ARGS__); \
} \
} else { \
if (block) { \
dispatch_async(dispatch_get_main_queue(), ^(){ \
CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^{ \
block(__VA_ARGS__); \
}); \
}); \
} \
} \
} while(0)


#define FLOAT_ZERO                      0.00001f
#define FLOAT_EQUAL_ZERO(a)             (fabs(a) <= FLOAT_ZERO)
#define FLOAT_GREATER_THAN(a, b)        ((a) - (b) >= FLOAT_ZERO)
#define FLOAT_EQUAL_TO(a, b)            FLOAT_EQUAL_ZERO((a) - (b))
#define FLOAT_LESS_THAN(a, b)           ((a) - (b) <= -FLOAT_ZERO)
#define TYScreenWidth [[UIScreen mainScreen] bounds].size.width
#define TYScreenHeight [[UIScreen mainScreen] bounds].size.height


#define weakify(...) \\
autoreleasepool {} \\
metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)

#define strongify(...) \\
try {} @finally {} \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
metamacro_foreach(rac_strongify_,, __VA_ARGS__) \\
_Pragma("clang diagnostic pop")


#endif /* TYDefined_h */
