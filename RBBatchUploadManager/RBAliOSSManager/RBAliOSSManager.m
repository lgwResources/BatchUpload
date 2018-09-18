//
//  RBAliOSSManager.m
//  RepairBang
//
//  Created by 刘功武 on 2018/8/29.
//  Copyright © 2018年 卓众. All rights reserved.
//

#import "RBAliOSSManager.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>

#define alysts_token [NSString stringWithFormat:@"%@%@",[RBNetworkHelper baseUrl],@"/c/alysts.token"]

static NSString *const AliYunHost       = @"http://oss-cn-beijing.aliyuncs.com/";
static NSString *const AliYunImageUrl   = @"http://banbanapp.oss-cn-beijing.aliyuncs.com/";

@interface RBAliOSSManager ()

@property (nonatomic, copy) NSString *accessKeyId;
@property (nonatomic, copy) NSString *accessKeySecret;
@property (nonatomic, copy) NSString *expiration;
@property (nonatomic, copy) NSString *securityToken;

@end

@implementation RBAliOSSManager
RBOBJECT_SINGLETON_BOILERPLATE(RBAliOSSManager, sharedManager)

#pragma mark -上传任务
- (void)uploadImages:(NSArray<UIImage *> *)images
            fileNames:(NSArray<NSString *> *)fileNames
            completionHandler:(void(^)(NSArray<NSString *> *names, RBBatchUploadState state))completionHandler {
    if (images.count == 0 || [NSString isEmpty:self.accessKeyId] || [NSString isEmpty:self.accessKeySecret] || [NSString isEmpty:self.securityToken]) {
        !completionHandler ? : completionHandler(nil,RBBatchUploadFailed);
        return;
    }
    
    id<OSSCredentialProvider> credential    = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:[RBAliOSSManager sharedManager].accessKeyId secretKeyId:[RBAliOSSManager sharedManager].accessKeySecret securityToken:[RBAliOSSManager sharedManager].securityToken];
    OSSClient *client                       = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential];
    
    /**初始化上传需要的参数*/
    NSMutableArray *dataArray   = @[].mutableCopy;
    NSMutableArray *keyArray    = @[].mutableCopy;
    for (int i = 0; i<images.count; i ++) {
        NSData *data = [images[i] scaleBatchUploadImage];
        if (data != nil) {
            [dataArray addObject:data];
            NSString *fileName = fileNames[i];
            NSString *imageName = [NSString batchUploadKeyType:fileName suffix:[data imageFormatType]];
            [keyArray addObject:imageName];
        }
    }
    NSMutableArray *resultArray = @[].mutableCopy;
    /**获取全局并发队列 并创建group 用于多图上传队列*/
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_apply(images.count, queue, ^(size_t index){
        dispatch_group_enter(group);
        /**采用group的异步执行方法将block追加到定义的全局并发队列queue中，并且等待全部结束处理执行*/
        dispatch_group_async(group, queue, ^{
            OSSPutObjectRequest *put    = [OSSPutObjectRequest new];
            put.bucketName              = @"banbanapp";
            NSString *imageName         = keyArray[index];
            put.objectKey               = imageName;
            put.uploadingData           = dataArray[index];
            OSSTask *putTask            = [client putObject:put];
            [putTask waitUntilFinished];
            if (!putTask.error) {
                NSLog(@"上传图片成功");
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",AliYunImageUrl,keyArray[index]];
                if (imageName.length) {
                    [resultArray addObject:imageUrl];
                }
                
            }else {
                NSLog(@"上传图片失败");
            }
            dispatch_group_leave(group);

        });
    });
    /**group内的任务完成通知*/
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completionHandler) {
            completionHandler(resultArray ,resultArray.count>0?RBBatchUploadSuccess:RBBatchUploadFailed);
        }
    });
}

#pragma mark -获取并设置阿里配置信息
- (void) setAliOSSConfiguration {
    RB_WEAKSELF;
    [RBNetworkHelper GET:alysts_token parameters:nil success:^(id responseObject) {
        NSDictionary *head = responseObject;
        if ([head[@"code"] isEqual:@(200)]) {
            NSDictionary *dic           = head[@"data"];
            weakSelf.accessKeyId        = [dic objectForKey:@"AccessKeyId"];
            weakSelf.accessKeySecret    = [dic objectForKey:@"AccessKeySecret"];
            weakSelf.expiration         = [dic objectForKey:@"Expiration"];
            weakSelf.securityToken      = [dic objectForKey:@"SecurityToken"];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
