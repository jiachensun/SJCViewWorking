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
        NSLog(@"错误：图片为空！");
        return nil;
    } else if (name == nil) {
        NSLog(@"错误：水印信息为空！");
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
        NSLog(@"错误：图片为空！");
        return nil;
    } else if (name == nil) {
        NSLog(@"错误：水印信息为空！");
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

@end
