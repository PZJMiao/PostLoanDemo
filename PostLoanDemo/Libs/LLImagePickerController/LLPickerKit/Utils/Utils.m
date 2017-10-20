//
//  Utils.m
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/16.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "iPhoneVersion.h"
#import "FunctionDefines.h"
#import "LLImageHandler.h"
#import "LLImageSelectHandler.h"
#import "ALAsset+LLAdd.h"
#import "PHImageModel.h"

@implementation Utils

+ (void)addScaleAnimation:(UIView *)totalView {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.duration = 0.4f;
    NSValue *value0 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25, 1.25, 1)];
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    NSValue *value4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)];
    NSValue *value5 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
    animation.values = @[value0,
                         value1,
                         value2,
                         value3,
                         value4,
                         value5];
    if (totalView.layer) {
        [totalView.layer addAnimation:animation forKey:nil];
    }
}

+ (UILabel *)building:(NSInteger)numberOfLines textColor:(UIColor *)textColor textAligment:(NSTextAlignment)textAligment font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = numberOfLines;
    label.textColor = textColor;
    label.textAlignment = textAligment;
    label.font = font;
    return label;
}

+ (UILabel *)building:(NSInteger)numberOfLines textColor:(UIColor *)textColor textAligment:(NSTextAlignment)textAligment font:(UIFont *)font superview:(UIView *)superview {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = numberOfLines;
    label.textColor = textColor;
    label.textAlignment = textAligment;
    label.font = font;
    [superview addSubview:label];
    return label;
}

+ (NSString *)replaceEnglishAssetCollectionNamme:(NSString *)englishName {
    if([englishName isEqualToString:@"My Photo Stream"]) {
        return @"我的照片流";
    }
    if([englishName isEqualToString:@"Selfies"]) {
        return @"自拍";
    }
    if([englishName isEqualToString:@"Bursts"]) {
        return @"连拍";
    }
    if([englishName isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    }
    if([englishName isEqualToString:@"Favorites"]) {
        return @"喜欢";
    }
    if([englishName isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    }
    if([englishName isEqualToString:@"Videos"]) {
        return @"视频";
    }
    if([englishName isEqualToString:@"Panoramas"]) {
        return @"全景";
    }
    if([englishName isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }
    if([englishName isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    }
    return englishName;
}

//+ (void)loadingResultAssetsWithBlock:(void(^)(NSArray <UIImage *>*images,NSMutableArray *videoArr))block {
+ (void)loadingResultAssetsWithBlock:(void(^)(NSMutableArray *imageArr,NSMutableArray *videoArr,NSArray<PHAsset *> *assetsArr))block {

    if (iOS8Upwards) {
        dispatch_group_t loadingImageGroup = dispatch_group_create();
        __block NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        //add by pzj 2017-10-17 视频相关新增加
        NSMutableArray *videoArray = [[NSMutableArray alloc] init];
        NSMutableArray *assetsArray = [[NSMutableArray alloc] init];
        NSInteger pickerType = 0;
        
        /****/
        for (PHAsset *asset in [LLImageSelectHandler instance].selectedAssets) {
            dispatch_group_enter(loadingImageGroup);
            if ([LLImageSelectHandler instance].needOriginal) {
                [asset original:^(UIImage *result, NSDictionary *info) {
                    PHImageModel *model = [[PHImageModel alloc] init];
                    model.image = result;
                    model.phasset = asset;
                    [assetsArray addObject:asset];
                    [imageArray addObject:model];
                    dispatch_group_leave(loadingImageGroup);
                }];
            } else {
                if (asset.mediaType == 1) {//照片
                    pickerType = 1;
                    [asset requestImageForTargetSize:[UIScreen mainScreen].bounds.size resultHandler:^(UIImage *result, NSDictionary *info) {
                        PHImageModel *model = [[PHImageModel alloc] init];
                        model.image = result;
                        model.phasset = asset;
                        [assetsArray addObject:asset];
                        [imageArray addObject:model];
                        dispatch_group_leave(loadingImageGroup);
                    }];
                }else if (asset.mediaType == 2){//视频
                 /*******/
                    pickerType = 2;

                    [asset requestMovieImageForTargetSize:[UIScreen mainScreen].bounds.size resultHandler:^(UIImage *result, NSDictionary *info, PHAsset *phAsset) {
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            NSLog(@"result = %@ ,phAsset = %@ , info =   %@",result,phAsset,info);
                            PHImageModel *model = [[PHImageModel alloc] init];
                            model.imageName = [[[info objectForKey:@"PHImageFileSandboxExtensionTokenKey"] componentsSeparatedByString:@";"] lastObject].lastPathComponent;
                            NSString *url = [[[info objectForKey:@"PHImageFileSandboxExtensionTokenKey"] componentsSeparatedByString:@";"] lastObject];
                            
                            url = [@"file://" stringByAppendingString:url];
                            NSURL *videoURL = [NSURL URLWithString:url];
                            model.url = videoURL;
                            model.isImage = NO;
                            model.phasset = phAsset;
                            model.image = result;
                            [assetsArray addObject:phAsset];
                            [videoArray addObject:model];
                            dispatch_group_leave(loadingImageGroup);
                        });
                    }];
                /*******/
                }
            }
        }
       
        
        /****/
        
        dispatch_group_notify(loadingImageGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (pickerType == 1) {
                    NSMutableArray *result = [NSMutableArray arrayWithArray:imageArray];
                    NSMutableArray *asset = [NSMutableArray arrayWithArray:assetsArray];
                    Block_exe(block, result,nil,asset);
                    [[LLImageSelectHandler instance] removeAllAssets];
                    [LLImageSelectHandler instance].needOriginal = NO;
                }else if (pickerType == 2){
                    NSMutableArray *video = [NSMutableArray arrayWithArray:videoArray];
                    NSMutableArray *asset = [NSMutableArray arrayWithArray:assetsArray];
                    Block_exe(block, nil,video,asset);
                    [[LLImageSelectHandler instance] removeAllAssets];
                    [LLImageSelectHandler instance].needOriginal = NO;
                }
                
            });
        });
    } else {
//        NSMutableArray *images = [NSMutableArray array];
//        for (ALAsset *asset in [LLImageSelectHandler instance].selectedAssets) {
//            if ([LLImageSelectHandler instance].needOriginal) {
//                [images addObject:[asset fullResolutionImage]];
//            } else {
//                [images addObject:[asset fullScreenImage]];
//            }
//        }
//        NSArray <UIImage *>*result = [NSArray arrayWithArray:images];
//        Block_exe(block, result,nil);
//        [[LLImageSelectHandler instance] removeAllAssets];
//        [LLImageSelectHandler instance].needOriginal = NO;
    }
}



@end
