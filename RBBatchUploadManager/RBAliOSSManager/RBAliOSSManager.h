//
//  RBAliOSSManager.h
//  RepairBang
//
//  Created by 刘功武 on 2018/8/29.
//  Copyright © 2018年 卓众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBBatchUploadManager.h"
/**阿里云图片上传管理类*/
@interface RBAliOSSManager : RBBatchUploadManager
+ (instancetype)sharedManager;
/**获取并设置阿里配置信息*/
- (void) setAliOSSConfiguration;

/**上传任务*/
- (void)uploadImages:(NSArray<UIImage *> *)images
           fileNames:(NSArray<NSString *> *)fileNames
   completionHandler:(void(^)(NSArray<NSString *> *names, RBBatchUploadState state))completionHandler;

@end
