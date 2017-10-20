//
//  PHImageModel.h
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/17.
//  Copyright © 2017年 pzj. All rights reserved.
//

/*
 * 视频model
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PHImageModel : NSObject

@property (nonatomic, strong) NSData *date;

@property (nonatomic,strong) UIImage * image;

@property (nonatomic,strong) NSString * imageName;

@property (nonatomic,assign) BOOL isImage;

@property (nonatomic,strong) NSURL * url;

@property (nonatomic,strong) NSData * data;

@property (nonatomic,strong) NSString * URLInPotoes;

@property (nonatomic,strong) PHAsset * phasset;

@end
