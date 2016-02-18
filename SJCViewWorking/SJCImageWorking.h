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
 *  @param img  待加水印图片
 *  @param name 水印
 *
 *  @return 水印图片
 */
-(UIImage *)markFourCorners:(UIImage *)img withName:(NSString *)name;

/**
 *  添加水印 (左上角)
 *
 *  @param img  待加水印图片
 *  @param name 水印
 *
 *  @return 水印图片
 */
-(UIImage *)markLeftCorner:(UIImage *)img withName:(NSString *)name;

@end
