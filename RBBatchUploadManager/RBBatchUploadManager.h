//
//  RBBatchUploadManager.h
//  RepairBang
//
//  Created by 刘功武 on 2018/9/13.
//  Copyright © 2018年 卓众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+BatchUploadExtension.h"
#import "NSData+BatchUploadExtension.h"
#import "UIImage+BatchUploadExtension.h"

typedef NS_ENUM(NSInteger, RBBatchUploadState) {
    RBBatchUploadFailed   = 0,
    RBBatchUploadSuccess  = 1
};

/**
 * 批量上传回调
 * @param  keyArray     图片组上传后的key数组
 * @param  uploadState  上传成功或失败状态
 */
typedef void(^RBBatchCompletionHandler)(NSArray<NSString *> *keyArray, RBBatchUploadState uploadState);

/**上传图片管理类 以后替换第三方SDK时不需要找各个文件替换 只修改这一个文件即可*/
@interface RBBatchUploadManager : NSObject

/**
 * 上传单张图片
 * @param  image             图片
 * @param  fileName          图片名称
 * @param  completionHandler 上传成功的回调
 */
+ (void)uploadImage:(UIImage *)image fileName:(NSString *)fileName successBlock:(RBBatchCompletionHandler)completionHandler;

/**
 * 上传多张图片
 * @param  imgArray          图片数组
 * @param  fileNames         图片名称数组
 * @param  completionHandler 上传成功的回调
 */
+ (void)uploadImageArray:(NSArray *)imgArray fileNames:(NSArray<NSString *> *)fileNames successBlock:(RBBatchCompletionHandler)completionHandler;

@end
