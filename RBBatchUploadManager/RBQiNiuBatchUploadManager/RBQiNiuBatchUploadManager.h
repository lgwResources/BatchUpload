//
//  RBQiNiuBatchUploadManager.h
//  RepairBang
//
//  Created by 刘功武 on 2018/7/28.
//  Copyright © 2018年 卓众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBBatchUploadManager.h"

/**七牛批量上传管理类*/
@interface RBQiNiuBatchUploadManager : RBBatchUploadManager
+ (instancetype)sharedManager;
/**设置七牛云*/
- (void) setQiNiuToken;

/**批量上传图片接口*/
- (void)uploadImages:(NSArray<UIImage *> *)images
           fileNames:(NSArray<NSString *> *)fileNames
   completionHandler:(void(^)(NSArray<NSString *> *names, RBBatchUploadState state))completionHandler;
@end
