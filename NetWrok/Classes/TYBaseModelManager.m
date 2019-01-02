//
//  TYBaseModel.m
//  TYVideoPlayerDemo
//
//  Created by yongqiang li on 2018/9/18.
//  Copyright © 2018 yongqiang. All rights reserved.
//

#import "TYBaseModelManager.h"
#import "TYHttpNetWorkConfig.h"
#import "AFNetworking.h"
#import "TYDefined.h"

#import "TYHttpSessionManager.h"

typedef NS_ENUM (NSInteger, TYNetWorkErrorType) {
    TYNetWorkErrorUnknown = 10001,   // 未知错误
    TYNetWorkErrorDataNULL = 10002,
    //
};

//#define  BASEURLTANGYI @"https://api.tangyishipin.com"

#define  BASEURLTANGYI APIURL

@interface TYBaseModelManager()

@property (nonatomic) NSDictionary *localParams;

@end

@implementation TYBaseModelManager
//
- (id)init
{
    self = [super init];
    if(self){

    }
    return self;
}

- (NSDictionary *)localParams
{
    if (!_localParams) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSDictionary *baseParams = [TYHttpNetWorkConfig shareInstance].baseParams;
        NSString *deviceId = baseParams[@"deviceId"];
        if (deviceId.length > 0) {
            params[@"deviceUuid"] = deviceId;
        }
        NSInteger deviceType = [baseParams[@"deviceType"] integerValue];
        params[@"deviceType"] = @(deviceType);

        NSString *version = baseParams[@"version"];
        if (version.length > 0) {
            params[@"version"] = version;
        }
        NSString *osVersion = baseParams[@"osVersion"];
        if (osVersion.length > 0) {
            params[@"osVersion"] = osVersion;
        }
        _localParams = params.copy;
    }
    return _localParams;

}

- (void)getFromTangyiMobilePath:(NSString *)path withURLParameters:(NSDictionary *)URLParameterDictionary finished:(TYModelRequestCallback)finishedCallback
{
    //
    NSString *URLString = [self _tangyiBaseURLStringWithPath:path];

    //
    URLString = [self _appendBaseControlPath:URLString  withParameters:URLParameterDictionary];
    NSURL *url = [NSURL URLWithString:URLString];
    if (url == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSString *encodedString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop

        url = [NSURL URLWithString:encodedString];
    }
    AFHTTPSessionManager *manager = [self getSessionManager];
    NSLog(@"url=%@  parameters=%@",url.absoluteString,URLParameterDictionary);
    [manager GET:url.absoluteString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"responseObject =%@",responseObject);

        [self _hotelCommonCallback:responseObject error:nil callback:finishedCallback];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error =%@",error);

        [self _hotelCommonCallback:nil error:error callback:finishedCallback];
    }];

}

- (AFHTTPSessionManager *)getSessionManager
{
    AFHTTPSessionManager *manager = [TYHttpSessionManager manager];
    NSDictionary *baseParams = [TYHttpNetWorkConfig shareInstance].baseParams;
    NSString *token = baseParams[@"userToken"]; // 添加token
    if (token.length > 0) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    }else {
        [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];

    }
    return  manager;
}

- (void)postFromTangyiMobilePath:(NSString *)path withURLParameters:(NSDictionary *)URLParameterDictionary bodyParameters:(NSDictionary *)bodyParameterDictionary finished:(TYModelRequestCallback)finishedCallback
{

    //
    NSString *URLString = [self _tangyiBaseURLStringWithPath:path];

    //
    URLString = [self _appendBaseControlPath:URLString withParameters:URLParameterDictionary];
    NSURL *url = [NSURL URLWithString:URLString];
    if (url == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSString *encodedString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop

        url = [NSURL URLWithString:encodedString];
    }

    AFHTTPSessionManager *manager = [self postSessionManager];
    NSLog(@"url =%@ /n parameters =%@",url.absoluteString,bodyParameterDictionary);

    [manager POST:url.absoluteString parameters:bodyParameterDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject =%@",responseObject);
        [self _hotelCommonCallback:responseObject error:nil callback:finishedCallback];
//        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post error =%@",error);
        [self _hotelCommonCallback:nil error:error callback:finishedCallback];
//        [manager.session finishTasksAndInvalidate];
    }];
}

- (AFHTTPSessionManager *)postSessionManager
{
    AFHTTPSessionManager *manager = [TYHttpSessionManager postManager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    NSDictionary *baseParams = [TYHttpNetWorkConfig shareInstance].baseParams;

    NSString *token = baseParams[@"userToken"];
    if (token.length > 0) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    }
    return  manager;
}

//上传文件
- (void)postToURL:(NSString *)path
  withURLParameters:(NSDictionary *)URLParameterDictionary
     bodyParameters:(NSDictionary *)bodyParameterDictionary
  uploadingFilePath:(NSString *)dataPath
     uploadProgress:(TYUploadProgressBlock)uploadBlock
           finished:(TYModelRequestCallback)finishedCallback
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //
    NSString *URLString = [self _tangyiBaseURLStringWithPath:path];
    //
    URLString = [self _appendBaseControlPath:URLString withParameters:URLParameterDictionary];

    [manager POST:URLString parameters:bodyParameterDictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // to do
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self _hotelCommonCallback:responseObject error:nil callback:finishedCallback];
        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self _hotelCommonCallback:nil error:error callback:finishedCallback];
        [manager.session finishTasksAndInvalidate];
    }];
}

- (void)_hotelCommonCallback:(id)object error:(NSError *)error callback:(TYModelRequestCallback)callback
{
    if (error) {
        NSLog(@"error ==== %@",error);
        callback(nil,TYNetWorkErrorUnknown, error);
        return;
    }

    // JSON处理，去掉NULL
    if ([object isKindOfClass:[NSDictionary class]]) {
        object = [NSMutableDictionary dictionaryWithDictionary:object];
        [self _removeNSNULLForDict:object];
    } else {
        // 以后会定义我们自己error 后续补上
        NSError *myError = [self _errorTangyiWithCode:NSURLErrorUnknown description:@"tangyi:服务器数据格式错误"];
        NSLog(@"error ==== %@",myError);
        callback(nil,TYNetWorkErrorUnknown, myError);
        return;
    }
    // 专门检测糖衣后台的错误。
    if (object[@"statusCode"]){
        NSInteger status = [object[@"statusCode"] integerValue];
        NSString *message = object[@"resultMsg"];
        if (status != 0) {
            NSError *myError = [self _errorTangyiWithCode:status description:message];
            NSLog(@"error ==== %@",myError);
            callback(object,status, myError);
        } else {
            callback(object,0,nil);
        }
        return;
    }
    NSError *myError = [self _errorTangyiWithCode:TYNetWorkErrorUnknown description:@"tangyi:数据异常，没有状态码"];
    NSLog(@"error ==== %@",myError);
    callback(nil,TYNetWorkErrorDataNULL,myError);

}

- (NSError *)_errorTangyiWithCode:(NSInteger )code description:(NSString *)description
{
    NSDictionary *userInfoKey = @{NSLocalizedDescriptionKey:description};
    NSError *error = [[NSError alloc]initWithDomain:@"errorWithDomain:com.tangyi.www" code:code userInfo:userInfoKey];
    return error;
}

- (void)_removeNSNULLForDict:(NSMutableDictionary *)dict
{
    NSArray *allKey = [dict allKeys];
    for (id key in allKey) {
        if ([dict[key] isKindOfClass:[NSNull class]]) {
            [dict removeObjectForKey:key];
        } else if ([dict[key] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict[key]];
            [self _removeNSNULLForDict:mutableDict];
            dict[key] = mutableDict;
        } else if ([dict[key] isKindOfClass:[NSArray class]]) {
            NSArray *array = dict[key];
            NSMutableArray *mutalbeArray = [NSMutableArray arrayWithArray:array];
            [self _removeNSNULLForArray:mutalbeArray];
            [dict setObject:mutalbeArray forKey:key];
        }
    }
}

- (void)_removeNSNULLForArray:(NSMutableArray *)array
{
    NSInteger len = array.count;
    for (NSInteger i = 0; i < len; i++) {
        if (array.count > i) {
            if ([array[i] isKindOfClass:[NSNull class]]) {
                [array removeObjectAtIndex:i];
                i--;
            } else if ([array[i] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                [self _removeNSNULLForDict:dict];
                array[i] = dict;
            } else if ([array[i] isKindOfClass:[NSArray class]]) {
                NSMutableArray *mutalbeArray = [NSMutableArray arrayWithArray:array[i]];
                [self _removeNSNULLForArray:mutalbeArray];
                array[i] = mutalbeArray;
            }
        }

    }
}


- (NSString *)_tangyiBaseURLStringWithPath:(NSString *)path
{
    // 如果已经有HTTP前缀，不加酒店地址，直接返回
    if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
        return path;
    }
    NSString *URLString = nil;
#if DEBUG  // 测试地址和线上地址可以在这里替换
    URLString = [NSString stringWithFormat:@"%@%@",[TYHttpNetWorkConfig shareInstance].baseUrl,path];

#else
    URLString = [NSString stringWithFormat:@"%@%@",BASEURLTANGYI,path];

#endif

    return URLString;

}

- (NSString *)_appendBaseControlPath:(NSString *)path withParameters:(NSDictionary *)params
{
    //可以添加 通用参数 path 参数
    NSMutableDictionary *localParams = [[NSMutableDictionary alloc]initWithDictionary:self.localParams];
     NSDictionary *baseParams = [TYHttpNetWorkConfig shareInstance].baseParams;
    if ([baseParams[@"uid"] integerValue] == 0) {
        localParams[@"uid"] = @"0";
    } else {
        localParams[@"uid"]  = baseParams[@"uid"];
    }
    [localParams addEntriesFromDictionary:params];
    if (!localParams ) {
        return path;
    }
    NSArray *keys = localParams.allKeys;
    if (keys.count == 0) {
        return path;
    }
    //https://api.tangyi/base
    if ([path rangeOfString:@"?"].location == NSNotFound) {
        path = [NSString stringWithFormat:@"%@?",path];
        for (NSInteger i = 0; i < keys.count; i++) {
            if (i > 0) {
                path = [NSString stringWithFormat:@"%@&",path];
            }
            NSString *key = keys[i];
            id keyVaule = localParams[key];
            path = [NSString stringWithFormat:@"%@%@=%@",path,key,keyVaule];
        }
    } else {
        //https://api.tangyi/base?userid=123
        path = [NSString stringWithFormat:@"%@&",path];
        for (NSInteger i = 0; i < keys.count; i++) {
            if (i > 0) {
                path = [NSString stringWithFormat:@"%@&",path];
            }
            NSString *key = keys[i];
            id keyVaule = localParams[key];
            path = [NSString stringWithFormat:@"%@%@=%@",path,key,keyVaule];
        }
    }

    return path;
}

//下载文件
- (NSURLSessionDownloadTask *)downloadFromTangyiToUrl:(NSString *)pathURL
                                     downloadFilePath:(NSString *)localPath
                                     downloadProgress:(TYDownloadProgressBlock)progressBlock
                                             finished:(TYModelDownLoadCallback)finishedCallback
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pathURL]];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    /* 开始请求下载 */
//    @weakify(manager);
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                safeFinish(progressBlock,downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:localPath];

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {

        NSLog(@"下载完成");
        safeFinish(finishedCallback,request,filePath,error);
//        @strongify(manager);
        [manager.session finishTasksAndInvalidate];
    }];

    [downloadTask resume];
    return downloadTask;
}

//下载文件
- (NSURLSessionDownloadTask *)downloadFromTangyiToUrl:(NSString *)pathURL
                                     downloadFilePath:(NSString *)localPath
                                downloadBytesProgress:(TYDownloadBytesProgressBlock)progressBlock
                                             finished:(TYModelDownLoadCallback)finishedCallback
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pathURL]];
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {


    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:localPath];

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {

        NSLog(@"下载完成");
        safeFinish(finishedCallback,request,filePath,error);
//        @strongify(manager);
        [manager.session finishTasksAndInvalidate];
    }];

    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        safeFinish(progressBlock,bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    }];
    [downloadTask resume];
    return downloadTask;
}

- (void)dealloc
{
    NSLog(@"dealloc ==========================================TYBaseModelManager");
}

@end
