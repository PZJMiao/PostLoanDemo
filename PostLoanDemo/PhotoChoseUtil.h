//
//  PhotoChoseUtil.h
//  FHDemo
//
//  Created by 彭昭君 on 15/8/4.
//  Copyright (c) 2015年 FangLin. All rights reserved.
//

/*
 *  照片/拍照选择器
 *  封装的工具类
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "FileUtil.h"

@interface PhotoChoseUtil : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
   void (^selectedImageCallback)(NSObject *image);
}

+(PhotoChoseUtil *)shareInstance;
//选择相册
- (void) selectImage:(UIViewController *)vc isimage:(BOOL)imagestr image:(void (^)(NSObject *image))onImageSelected;
+ (void) selectImage:(UIViewController *)vc isimage:(BOOL)imagestr image:(void (^)(NSObject *image))onImageSelected;
//调用摄像头
- (void)photograph:(UIViewController *)vc isimage:(BOOL)imagestr image:(void (^)(NSObject *image))onImageSelected;
+ (void) photograph:(UIViewController *)vc isimage:(BOOL)imagestr image:(void (^)(NSObject *image))onImageSelected;
//- (void) takePhoto:(void (^)())takePhoto;

/*
 * 选择照片后最终要获得的是图片还是图片的路径
 * YES 为图片，NO为路径
 */
@property (assign,nonatomic)BOOL isImage;

/*
 * 将当前的那个viewController传过来，在他的基础上弹出相册框
 */

@end
