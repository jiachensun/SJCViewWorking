//
//  SJCImageWorking.h
//  SJCViewWorking
//
//  Created by sunjiachen on 16/2/18.
//  Copyright © 2016年 SJC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJCImageWorking : NSObject

/**
 *  添加水印 (四个角)
 *
 *  @param img  待处理图片
 *  @param name 水印
 *
 *  @return 结果图片
 */
-(UIImage *)markFourCorners:(UIImage *)img withName:(NSString *)name;

/**
 *  添加水印 (左上角)
 *
 *  @param img  待处理图片
 *  @param name 水印
 *
 *  @return 结果图片
 */
-(UIImage *)markLeftCorner:(UIImage *)img withName:(NSString *)name;

/**
 *  图片裁剪
 *
 *  @param img   待处理图片
 *  @param frame 裁剪尺寸
 *
 *  @return 结果图片
 */
- (UIImage *)cutImage:(UIImage *)img withFrame:(CGRect)frame;

/**
 *  彩色图转灰度图
 *
 *  @param img 待处理图片
 *
 *  @return 结果图片
 */
-(UIImage*)getGrayImage:(UIImage*)img;

@end
