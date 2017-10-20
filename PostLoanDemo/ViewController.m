//
//  ViewController.m
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/9.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import "ViewController.h"
#import "TakePictureVC.h"
#import "VideoVC.h"
#import "SoundRecodingVC.h"

#import "YMHTTPRequestTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"拍照",@"拍视频",@"录音"];
    for (int i = 0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+i*110, 80, 100, 50);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        [self.view addSubview:btn];
    }
    
    //临时添加
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(10+110, 180, 150, 50);
//    [btn setTitle:@"网络请求" forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor lightGrayColor];
//    [btn addTarget:self action:@selector(btnNetWorkClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
}
- (void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            NSLog(@"拍照");
            TakePictureVC *vc = [[TakePictureVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 101:
        {
            NSLog(@"拍视频");
            VideoVC *vc = [[VideoVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 102:
        {
            NSLog(@"录音");
            SoundRecodingVC *vc = [[SoundRecodingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)btnNetWorkClick:(UIButton *)btn
{

    NSString *baseUrl = @"https://221.0.171.243:4440/runproject/api/user_login";
//    NSString *baseUrl = @"https://10.1.84.32:4455/runproject/api/user_login";
    NSDictionary *dict = @{@"name":@"jin",
                           @"password":@"123456"
                           };
    [[YMHTTPRequestTool shareInstance] POST:baseUrl parameters:dict success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
