//
//  TYBaseModelManager.h
//  TYVideoPlayerDemo
//
//  Created by yongqiang li on 2018/9/18.
//  Copyright © 2018 yongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYError.h"



typedef void (^TYModelRequestCallback)(id data, NSInteger status, NSError *error);

/**
 *  定义上传的进度block
 *
 *  @param data              返回值
 *  @param error              错误
 */
typedef void (^TYModelDownLoadCallback)(id data, NSURL *fileURL, NSError *error);

/**
 *  定义上传的进度block
 *
 *  @param bytesWritten              已经上传的bytes大小
 *  @param totalBytesWritten         总共已经上传的bytes大小
 *  @param totalBytesExpectedToWrite 需要上传的总共bytes
 */
typedef void (^TYUploadProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

/**
 *  定义下载的进度block
 *
 *  @param bytesWritten               本次下载的bytes大小
 *  @param totalBytesWritten          已经下载的bytes
 *  @param totalBytesExpectedToWrite    资源的总量的bytes
 */
typedef void (^TYDownloadBytesProgressBlock)(long long bytesWritten, long long totalBytesWritten,long long totalBytesExpectedToWrite);

/**
 *  定义下载的进度block
 *
 *  @param progress                下载进度
 */
typedef void (^TYDownloadProgressBlock)(NSProgress *progress);


@interface TYBaseModelManager : NSObject

- (void)getFromTangyiMobilePath:(NSString *)path withURLParameters:(NSDictionary *)URLParameterDictionary finished:(TYModelRequestCallback)finishedCallback;

//
- (void)postFromTangyiMobilePath:(NSString *)path withURLParameters:(NSDictionary *)URLParameterDictionary bodyParameters:(NSDictionary *)bodyParameterDictionary finished:(TYModelRequestCallback)finishedCallback;


//上传文件暂时不可用
- (void )postToURL:(NSString *)pathURL
                    withURLParameters:(NSDictionary *)URLParameterDictionary
                       bodyParameters:(NSDictionary *)bodyParameterDictionary
                        uploadingFilePath:(NSString *)dataPath
                        uploadProgress:(TYUploadProgressBlock)uploadBlock
                        finished:(TYModelRequestCallback)finishedCallback;

//下载文件 现在进度
- (NSURLSessionDownloadTask *)downloadFromTangyiToUrl:(NSString *)pathURL
                           downloadFilePath:(NSString *)localPath
                           downloadProgress:(TYDownloadProgressBlock)progressBlock
                                   finished:(TYModelDownLoadCallback)finishedCallback;

// 下载
//下载文件进度 有文件下载大小btyes
- (NSURLSessionDownloadTask *)downloadFromTangyiToUrl:(NSString *)pathURL
                           downloadFilePath:(NSString *)localPath
                      downloadBytesProgress:(TYDownloadBytesProgressBlock)progressBlock
                                   finished:(TYModelDownLoadCallback)finishedCallback;


@end
