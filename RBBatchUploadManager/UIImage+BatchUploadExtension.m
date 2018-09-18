//
//  UIImage+BatchUploadExtension.m
//  RepairBang
//
//  Created by 刘功武 on 2018/9/14.
//  Copyright © 2018年 卓众. All rights reserved.
//

#import "UIImage+BatchUploadExtension.h"

@implementation UIImage (BatchUploadExtension)

#pragma mark -图片压缩（暂时写死480*800）先按照尺寸比例压缩，再进行质量压缩 使用尺寸为480*800,如果宽度小于高度 则会以宽度为480为基准压缩图片尺寸,反之,则会以高度为800为基准压缩图片尺寸
- (NSData *)scaleBatchUploadImage{
    CGFloat width   = screenWidth;
    CGFloat height  = screenHeight;
    CGFloat imageWith   = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGSize size         = CGSizeZero;
    if (imageWith > imageHeight) {
        if(width < imageWith){
            size = CGSizeMake(width, width/(imageWith/imageHeight));
        }else{
            size = CGSizeMake(imageWith, imageHeight);
        }
    } else{
        if (height < imageHeight) {
            size = CGSizeMake(imageWith/imageHeight*height, height);
        }else{
            size = CGSizeMake(imageWith, imageHeight);
        }
    }
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(scaleImage, 1);
}

@end
