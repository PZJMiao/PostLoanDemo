//
//  LLImageCollectionController.h
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/16.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LLBaseViewController.h"
#import "LLImageHandler.h"

@interface LLImageCollectionController : LLBaseViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, assign) NSInteger pickerType;//1--照片，2视频

@end
