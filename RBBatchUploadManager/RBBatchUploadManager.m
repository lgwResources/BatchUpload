//
//  RBBatchUploadManager.m
//  RepairBang
//
//  Created by 刘功武 on 2018/9/13.
//  Copyright © 2018年 卓众. All rights reserved.
//

#import "RBBatchUploadManager.h"
#import "RBAliOSSManager.h"

@implementation RBBatchUploadManager

#pragma mark -上传单张图片
+ (void)uploadImage:(UIImage *)image fileName:(NSString *)fileName successBlock:(RBBatchCompletionHandler)completionHandler {
    if (image == nil) {
        !completionHandler ? : completionHandler(@[],RBBatchUploadFailed);
        return;
    }
    
    NSString *fileNewName = [NSString stringWithFormat:@"%@%@",[NSString createTimeStampForBatchUpload],fileName.length?fileName:@""];
    /*阿里单图上传**/
    [[RBAliOSSManager sharedManager] uploadImages:@[image] fileNames:@[fileNewName] completionHandler:^(NSArray<NSString *> *names, RBBatchUploadState state) {
        if (completionHandler) {
            completionHandler(names, state);
        }
    }];
    
    /*七牛单图上传**/
//    [[RBQiNiuBatchUploadManager sharedManager] uploadImages:@[image] fileNames:@[key] completionHandler:^(NSArray<NSString *> *names, RBBatchUploadState state) {
//        if (completionHandler) {
//            completionHandler(names, state);
//        }
//    }];
    
}

#pragma mark -上传多张图片
+ (void)uploadImageArray:(NSArray *)imgArray fileNames:(NSArray<NSString *> *)fileNames successBlock:(RBBatchCompletionHandler)completionHandler {
    if (imgArray.count == 0) {
        !completionHandler ? : completionHandler(@[],RBBatchUploadFailed);
        return;
    }
    NSMutableArray *fileNameMD5Arr = [NSMutableArray array];
    for (NSString *fileName in fileNames) {
        NSString *fileNewName = [NSString stringWithFormat:@"%@%@",[NSString createTimeStampForBatchUpload],fileName.length?fileName:@""];
        if (key.length) {
            [fileNameMD5Arr addObject:fileNewName];
        }
    }
    
    /**阿里多图上传*/
    [[RBAliOSSManager sharedManager] uploadImages:imgArray fileNames:fileNameMD5Arr.mutableCopy completionHandler:^(NSArray<NSString *> *names, RBBatchUploadState state) {
        if (completionHandler) {
            completionHandler(names, state);
        }
    }];
    
    /**七牛多图上传*/
//    [[RBQiNiuBatchUploadManager sharedManager] uploadImages:imgArray fileNames:fileNameMD5Arr.mutableCopy completionHandler:^(NSArray<NSString *> *names, RBBatchUploadState state) {
//        if (completionHandler) {
//            completionHandler(names, state);
//        }
//    }];
}

@end
