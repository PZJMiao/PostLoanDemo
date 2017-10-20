//
//  FileSizeAtPath.h
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/20.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSizeAtPath : NSObject

/**
 * 单个文件的大小
 */
- (long long) fileSizeAtPath:(NSString*) filePath;
/**
 * 遍历文件夹获得文件夹大小，返回多少M
 */
- (float) folderSizeAtPath:(NSString*) folderPath;

@end
