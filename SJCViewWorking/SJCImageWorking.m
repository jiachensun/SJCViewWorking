//
//  SJCImageWorking.m
//  SJCViewWorking
//
//  Created by sunjiachen on 16/2/18.
//  Copyright © 2016年 SJC. All rights reserved.
//

#import "SJCImageWorking.h"

static SJCImageWorking *shareInstance = nil;

@implementation SJCImageWorking

+ (id)shareSJCImageManager {
    
    if (shareInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareInstance = [[SJCImageWorking alloc] init];
        });
    }
    return shareInstance;
}

//四个角的水印
-(UIImage *)markFourCorners:(UIImage *)img withName:(NSString *)name {
    
    if (img == nil) {
        NSLog(@"错误：图片为空 方法：markFourCorners:withName:");
        return nil;
    } else if (name == nil) {
        NSLog(@"错误：水印信息为空 方法：markFourCorners:withName:");
        return img;
    }
    NSString* mark = name;
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    NSDictionary *attr = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],   //设置字体
                           NSForegroundColorAttributeName : [UIColor redColor]      //设置字体颜色
                           };
    [mark drawInRect:CGRectMake(0, 10, 80, 32) withAttributes:attr];
    [mark drawInRect:CGRectMake(w - 80, 10, 80, 32) withAttributes:attr];
    [mark drawInRect:CGRectMake(w - 80, h - 32 - 10, 80, 32) withAttributes:attr];
    [mark drawInRect:CGRectMake(0, h - 32 - 10, 80, 32) withAttributes:attr];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

//左上角的水印
-(UIImage *)markLeftCorner:(UIImage *)img withName:(NSString *)name {
    
    if (img == nil) {
        NSLog(@"错误：图片为空 方法：markLeftCorner:withName:");
        return nil;
    } else if (name == nil) {
        NSLog(@"错误：水印信息为空 方法：markLeftCorner:withName:");
        return img;
    }
    NSString* mark = name;
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    NSDictionary *attr = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],   //设置字体
                           NSForegroundColorAttributeName : [UIColor redColor]      //设置字体颜色
                           };
    [mark drawInRect:CGRectMake(0, 10, 80, 32) withAttributes:attr];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

//裁剪图片
- (UIImage *)cutImage:(UIImage *)img withFrame:(CGRect)frame {
    
    if (img == nil) {
        NSLog(@"错误：图片为空 方法：cutImage:withFrame:");
        return nil;
    } else if (frame.size.height == 0 || frame.size.width == 0) {
        NSLog(@"错误：frame为空 方法：cutImage:withFrame:");
        return img;
    }
    CGImageRef cgImage = img.CGImage;
    cgImage = CGImageCreateWithImageInRect(cgImage, frame);
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return resultImage;
}

//彩色图转灰度图
-(UIImage*)getGrayImage:(UIImage*)img {
    
    if (img == nil) {
        NSLog(@"错误：图片为空 方法：getGrayImage:");
        return nil;
    }
    CGImageRef cgImage = img.CGImage;
    int width = img.size.width;
    int height = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        NSLog(@"异常：context为空 方法：getGrayImage:");
        return nil;
    }

    CGContextDrawImage(context,CGRectMake(0, 0, width, height), cgImage);
    
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    //延迟释放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CFRelease(cgImage);
    });
    return grayImage;
}

//图片旋转
- (UIImage *)rotationImage:(UIImage *)img withOrientation:(UIImageOrientation)orientation {
    
    CGImageRef imgRef = img.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;

    switch(orientation)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGContextRelease(context);
    CGImageRelease(imgRef);
    return imageCopy;
}

//修改图片尺寸
- (UIImage *)reSizeImage:(UIImage *)img withSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return reSizeImage;
}

@end
