//
//  AppDelegate.h
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/9.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

