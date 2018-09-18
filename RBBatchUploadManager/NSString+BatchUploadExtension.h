//
//  NSString+BatchUploadExtension.h
//  RepairBang
//
//  Created by 刘功武 on 2018/9/14.
//  Copyright © 2018年 卓众. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BatchUploadExtension)
/**
 * 字符串判空
 * @param  string  需要判空的自字符串
 * @return BOOL类型 YES为空字符
 */
+ (BOOL)isEmpty:(NSString *)string;
/**
 * 批量上传key值定义
 * @param  type   图片用途type
 * @param  suffix 图片类型后缀jpg或者是png或者其它
 */
+ (NSString *)batchUploadKeyType:(NSString *)type suffix:(NSString *)suffix;
/**获取当前时间戳*/
+ (NSString *)createTimeStampForBatchUpload;
@end
