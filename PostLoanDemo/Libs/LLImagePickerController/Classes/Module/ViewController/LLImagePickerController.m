//
//  LLImagePickerController.m
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/16.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LLImagePickerController.h"
#import "LLImageCollectionController.h"
#import "UINavigationBar+LLAdd.h"
#import "FunctionDefines.h"
#import "ConstDefine.h"
#import "LLImageSelectHandler.h"
#import "LLImageGroupController.h"
#import "PHImageModel.h"

@interface LLImagePickerController ()

@property (nonatomic, copy, readwrite) ALAssetsBlock alAssetsBlock;
@property (nonatomic, copy, readwrite) PHAssetsBlock phAssetsBlock;
@property (nonatomic, copy, readwrite) PHAssetsMovieBlock phAssetsMovieBlock;

@end

@implementation LLImagePickerController

#pragma mark -
#pragma mark - init methods
- (instancetype)init {
    self = [super initWithRootViewController:[[LLImageGroupController alloc] init]];
    if (self) {
        [self.navigationBar ll_setWeiXinStyle];
        self.allowSelectReturnType = NO;
    }
    return self;
}

- (instancetype)initWithType:(NSInteger)type{//1--照片，2--视频
    self = [super initWithRootViewController:[[LLImageGroupController alloc] initWithType:type]];
    if (self) {
        [self.navigationBar ll_setWeiXinStyle];
        self.allowSelectReturnType = NO;
    }
    return self;
}

- (instancetype)initWithMaxSelectedCount:(NSInteger)max {
    self = [super initWithRootViewController:[[LLImageGroupController alloc] init]];
    if (self) {
        [self.navigationBar ll_setWeiXinStyle];
        [[LLImageSelectHandler instance] setMaxSelectedCount:max];
        self.allowSelectReturnType = NO;
    }
    return self;
}

#pragma mark -
#pragma mark - deinit method
- (void)dealloc {
    LLog(@"%@", self);
    [[LLImageSelectHandler instance] removeAllAssets];
    [LLImageSelectHandler instance].needOriginal = NO;
}

#pragma mark -
#pragma mark - navigationBar style
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark - setter methods
- (void)setAutoJumpToPhotoSelectPage:(BOOL)autoJumpToPhotoSelectPage {
    _autoJumpToPhotoSelectPage = autoJumpToPhotoSelectPage;
    if (autoJumpToPhotoSelectPage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushToCollectionPageNotification object:nil];
    }
}

- (void)setMaxSelectedCount:(NSInteger)maxSelectedCount {
    _maxSelectedCount = maxSelectedCount;
    [[LLImageSelectHandler instance] setMaxSelectedCount:maxSelectedCount];
}

#pragma mark -
#pragma mark - callback
- (void)getSelectedALAssetsWithBlock:(ALAssetsBlock)block {
    self.alAssetsBlock = block;
}

- (void)getSelectedPHAssetsWithBlock:(PHAssetsBlock)block {
    self.phAssetsBlock = block;
}

- (void)getSelectedPHAssetsMovieWithBlock:(PHAssetsMovieBlock)block
{
    self.phAssetsMovieBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
