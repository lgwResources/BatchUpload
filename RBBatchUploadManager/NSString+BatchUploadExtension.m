//
//  NSString+BatchUploadExtension.m
//  RepairBang
//
//  Created by 刘功武 on 2018/9/14.
//  Copyright © 2018年 卓众. All rights reserved.
//

#import "NSString+BatchUploadExtension.h"

@implementation NSString (BatchUploadExtension)

#pragma mark -字符串判空
+ (BOOL)isEmpty:(NSString *)string {
    return [string isEqual:[NSNull null]] || string == nil || string.length == 0;
}

#pragma mark -批量上传key值定义
+ (NSString *)batchUploadKeyType:(NSString *)type suffix:(NSString *)suffix {
    return [NSString stringWithFormat:@"%@%@",type,suffix];
}

#pragma mark -获取当前时间戳
+ (NSString *)createTimeStampForBatchUpload {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    format.timeZone         = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString *oldString     = [format stringFromDate:[NSDate date]];
    NSDate *newDate         = [NSDate dateWithString:oldString format:@"yyyyMMddHHmmss"];
    NSTimeInterval interval = [newDate timeIntervalSince1970];
    NSString *string        = [NSString stringWithFormat:@"%f",interval];
    return [NSString stringWithFormat:@"%ld",(long)[string integerValue]];
}

@end
