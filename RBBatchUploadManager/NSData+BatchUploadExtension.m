//
//  NSData+BatchUploadExtension.m
//  RepairBang
//
//  Created by 刘功武 on 2018/9/14.
//  Copyright © 2018年 卓众. All rights reserved.
//

#import "NSData+BatchUploadExtension.h"

@implementation NSData (BatchUploadExtension)
#pragma mark -获取图片格式
- (NSString *) imageFormatType{
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF: return @".jpeg";
        case 0x89: return @".png";
        case 0x47: return @".gif";
        case 0x49:
        case 0x4D: return @".tiff";
        default: return @".undefine";
    }
    return nil;
}
@end
