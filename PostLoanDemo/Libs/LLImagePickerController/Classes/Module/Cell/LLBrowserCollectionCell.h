//
//  LLBrowserCollectionCell.h
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/17.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@class ALAsset;
@class PHImageModel;

@interface LLBrowserCollectionCell : UICollectionViewCell

- (void)handleSingleTapActionWithBlock:(dispatch_block_t)block;

- (void)reloadDataWithALAsset:(ALAsset *)asset;

- (void)reloadDataWithPHAsset:(PHAsset *)asset;

/*
 * 相册中视频
 * 2017-10-12 add by pzj
 */
- (void)reloadDataWithMoviePHAsset:(PHAsset *)asset resultHandler:(void(^)(PHImageModel *model,PHAsset *phAsset))resultHandler;

@end
