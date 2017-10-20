//
//  LCameraViewController.h
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/23.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@class PHImageModel;

typedef NS_ENUM(NSInteger, CameraType) {
    CameraTypeImage             = 0,//拍照
    CameraTypeMovie             = 1,//录制视频（有声音）
};

typedef void (^CameraBlock) (PHImageModel *imageModel, PHAsset *phAsset);
typedef void (^CameraMovieBlock) (PHImageModel *videoModel, PHAsset *phAsset);

@interface LLCameraViewController : UIImagePickerController

/** 拍摄照片回调方法
 * @brief image: 拍摄获取的图片, info: 图片的相关信息
 */
- (void)getResultFromCameraWithBlock:(CameraBlock)block;
/** 拍摄视频呢回调方法
 * @brief videoPath: 拍摄获取的视频url, info: 视频的相关信息
 */
- (void)getResultFromCameraMovieWithBlock:(CameraMovieBlock)block;

@property (assign,nonatomic,readwrite) CameraType cameraType;

@end
