//
//  SoundRecordModel.h
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/19.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundRecordModel : NSObject

@property (nonatomic, copy) NSString *filePath;//录音路径
@property (nonatomic, copy) NSURL *filePathUrl;//录音路径
@property (nonatomic, copy) NSString *dateStr;//录音时间(时间)
@property (nonatomic, copy) NSString *dateStampStr;//录音时间(相应的时间戳)
@property (nonatomic, copy) NSString *recordTime;//录音时长
@property (nonatomic, assign) BOOL isSelectPlay;

@end
