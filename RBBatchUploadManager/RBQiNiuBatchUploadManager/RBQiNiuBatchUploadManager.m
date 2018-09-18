//
//  RBQiNiuBatchUploadManager.m
//  RepairBang
//
//  Created by 刘功武 on 2018/7/28.
//  Copyright © 2018年 卓众. All rights reserved.
//

#import "RBQiNiuBatchUploadManager.h"
#import "QiniuSDK.h"

#define qiniu_token [NSString stringWithFormat:@"%@%@",[RBNetworkHelper baseUrl],@"/c/qiniu.token"]

@interface RBQiNiuBatchUploadManager ()
@property (nonatomic, copy) NSString *qiniuToken;
@property (nonatomic, copy) NSString *qiniuUrl;
@end

@implementation RBQiNiuBatchUploadManager
RBOBJECT_SINGLETON_BOILERPLATE(RBQiNiuBatchUploadManager, sharedManager)

#pragma mark -批量上传图片接口
- (void)uploadImages:(NSArray<UIImage *> *)images
           fileNames:(NSArray<NSString *> *)fileNames
   completionHandler:(void(^)(NSArray<NSString *> *names, RBBatchUploadState state))completionHandler {
    if ([NSString isEmpty:self.qiniuToken]) {
        !completionHandler ? : completionHandler(nil, RBBatchUploadFailed);
        return;
    }
    
    /**如果无图片可上传 直接执行block,这里无图片等上传此处作为成功处理 error传nil*/
    if (images.count == 0) {
        !completionHandler ? : completionHandler(nil,RBBatchUploadFailed);
        return;
    }
    
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
            QNUploadManager *manager = [QNUploadManager sharedInstanceWithConfiguration:nil];
            [manager putData:dataArray[index] key:keyArray[index] token:[RBQiNiuBatchUploadManager sharedManager].qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (!info.error && resp) {
                    NSString *keyUrl = [NSString stringWithFormat:@"%@%@",[RBQiNiuBatchUploadManager sharedManager].qiniuUrl,key];
                    [resultArray addObject:keyUrl];
                }
                dispatch_group_leave(group);
            } option:nil];
        });
    });
    /**group内的任务完成通知*/
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completionHandler) {
            completionHandler(resultArray ,resultArray.count>0?RBBatchUploadSuccess:RBBatchUploadFailed);
        }
    });
}

#pragma mark -获取并设置七牛云Token
- (void) setQiNiuToken {
    RB_WEAKSELF;
    [RBNetworkHelper GET:qiniu_token parameters:nil success:^(id responseObject) {
        NSDictionary *head = responseObject;
        if ([head[@"code"] isEqual:@(200)]) {
            NSDictionary *dic   = head[@"data"];
            weakSelf.qiniuToken = [dic objectForKey:@"token"];
            weakSelf.qiniuUrl   = [dic objectForKey:@"domain"];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
