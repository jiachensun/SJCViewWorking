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
    
    if (img == nil) {
        NSLog(@"错误：图片为空 方法：rotationImage:withOrientation:");
        return nil;
    }
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation)
    {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, img.size.height, img.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = - M_PI_2;
            rect = CGRectMake(0, 0, img.size.height, img.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, img.size.width, img.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, img.size.width, img.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), img.CGImage);
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGContextRelease(context);
    return newPic;
}

@end
