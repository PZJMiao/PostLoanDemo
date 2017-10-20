//
//  Utils.h
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/16.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface Utils : NSObject

+ (void)addScaleAnimation:(UIView *)totalView;

+ (UILabel *)building:(NSInteger)numberOfLines textColor:(UIColor *)textColor textAligment:(NSTextAlignment)textAligment font:(UIFont *)font;

+ (UILabel *)building:(NSInteger)numberOfLines textColor:(UIColor *)textColor textAligment:(NSTextAlignment)textAligment font:(UIFont *)font superview:(UIView *)superview;

+ (NSString *)replaceEnglishAssetCollectionNamme:(NSString *)englishName;

/*
 * 选择完照片或视频信息回调
 * add by pzj 2017-10-17
 */
//+ (void)loadingResultAssetsWithBlock:(void(^)(NSArray <UIImage *>*images,NSMutableArray *videoArr))block;
+ (void)loadingResultAssetsWithBlock:(void(^)(NSMutableArray *imageArr,NSMutableArray *videoArr,NSArray<PHAsset *> *assetsArr))block;

@end
