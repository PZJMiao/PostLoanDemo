//
//  LLImageGroupController.m
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/16.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LLImageGroupController.h"
#import "LLImageGroupCell.h"
#import "LLImageCollectionController.h"

static NSString *const reUse = @"reUse";

@interface LLImageGroupController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LLImageHandler *imageHandler;
@property (nonatomic, copy) NSArray <ALAssetsGroup *>*assetGroups;
@property (nonatomic, copy) NSArray <PHAssetCollection *>*assetCollections;
@property (nonatomic, assign) BOOL pushToCollectionPage;
@property (nonatomic, assign) NSInteger pickerType;//0--照片，1--视频

@end

@implementation LLImageGroupController

#pragma mark -
//#pragma mark - base methods
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [self buildingParams];
//        [self buildingUI];
//        [self addObserver];
////        [self loadMovies];
//        [self loadingPhotos];
//    }
//    return self;
//}
- (instancetype)initWithType:(NSInteger)type{//1--照片，2--视频 add by pzj
    self = [super init];
    if (self) {
        self.pickerType = type;
        [self buildingParams];
        [self buildingUI];
        [self addObserver];
        if (self.pickerType == 1) {
            [self loadingPhotos];
        }else{
            [self loadMovies];
        }
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[LLImageSelectHandler instance] removeAllAssets];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
}

- (void)buildingParams {
    self.title = self.pickerType==1?@"照片":@"视频";
    self.imageHandler = [[LLImageHandler alloc] init];
    self.pushToCollectionPage = NO;
}

- (void)buildingUI {
    [self rightBarButton:@"取消" selector:@selector(cancelAction:) delegate:self];
    [self.tableView registerClass:[LLImageGroupCell class] forCellReuseIdentifier:reUse];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePushToCollectionPage:) name:kPushToCollectionPageNotification object:nil];
}
- (void)loadMovies
{
    WeakSelf(self)
    if (iOS8Upwards) {
        [_imageHandler enumeratePHAssetMovieCollectionsWithResultHandler:^(NSArray<PHAssetCollection *> *result) {
            weakSelf.assetCollections = [NSArray arrayWithArray:result];
            [weakSelf.tableView reloadData];
            if (weakSelf.pushToCollectionPage) {
                if (weakSelf.assetCollections.count > 2) {
                    [weakSelf pushToMovieNextPage:2 animated:NO];
                } else {
                    [weakSelf pushToMovieNextPage:weakSelf.assetCollections.count animated:NO];
                }
            }
        }];
        
    }
}

- (void)loadingPhotos {
    WeakSelf(self)
    if (iOS8Upwards) {
        [_imageHandler enumeratePHAssetCollectionsWithResultHandler:^(NSArray<PHAssetCollection *> *result) {
            weakSelf.assetCollections = [NSArray arrayWithArray:result];
            [weakSelf.tableView reloadData];
            if (weakSelf.pushToCollectionPage) {
                if (weakSelf.assetCollections.count > 2) {
                    [weakSelf pushToNextPage:2 animated:NO];
                } else {
                    [weakSelf pushToNextPage:weakSelf.assetCollections.count animated:NO];
                }
            }
        }];
    } else {
        [_imageHandler enumerateALAssetsGroupsWithResultHandler:^(NSArray<ALAssetsGroup *> *result) {
            weakSelf.assetGroups = [NSArray arrayWithArray:result];
            [weakSelf.tableView reloadData];
            if (weakSelf.pushToCollectionPage) {
                if (weakSelf.assetGroups.count > 0) {
                    [weakSelf pushToNextPage:weakSelf.assetGroups.count - 1 animated:NO];
                }
            }
        }];
    }
}

#pragma mark -
#pragma mark - tableView protocol methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (iOS8Upwards) {
        return self.assetCollections.count;
    }
    return self.assetGroups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LLImageGroupCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLImageGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:reUse forIndexPath:indexPath];
    if (iOS8Upwards) {
        [cell reloadDataWithAssetCollection:self.assetCollections[indexPath.row]];
    } else {
        [cell reloadDataWithAssetsGroup:self.assetGroups[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToNextPage:indexPath.row animated:YES];
}

#pragma mark -
#pragma mark - button click action methods
- (void)cancelAction:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
#pragma mark - observer response methods
- (void)handlePushToCollectionPage:(NSNotification *)notification {
    self.pushToCollectionPage = YES;
}

#pragma mark - 
#pragma mark - other methods
- (void)pushToNextPage:(NSInteger)index animated:(BOOL)animated {
    if (iOS8Upwards && index >= self.assetCollections.count) {
        return;
    }
    if (!iOS8Upwards && index >= self.assetGroups.count) {
        return;
    }
    LLImageCollectionController *imageCollectionVC = [[LLImageCollectionController alloc] init];
    imageCollectionVC.pickerType = self.pickerType;
    if (iOS8Upwards) {
        PHAssetCollection *collection = self.assetCollections[index];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        imageCollectionVC.assetCollection = collection;
        imageCollectionVC.fetchResult = fetchResult;
    } else {
        ALAssetsGroup *group = self.assetGroups[index];
        imageCollectionVC.assetsGroup = group;
    }
    [self.navigationController pushViewController:imageCollectionVC animated:animated];
}

- (void)pushToMovieNextPage:(NSInteger)index animated:(BOOL)animated {
    if (iOS8Upwards && index >= self.assetCollections.count) {
        return;
    }
    if (!iOS8Upwards && index >= self.assetGroups.count) {
        return;
    }
    LLImageCollectionController *imageCollectionVC = [[LLImageCollectionController alloc] init];
    imageCollectionVC.pickerType = self.pickerType;
    if (iOS8Upwards) {
        PHAssetCollection *collection = self.assetCollections[index];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        imageCollectionVC.assetCollection = collection;
        imageCollectionVC.fetchResult = fetchResult;
    } else {
        ALAssetsGroup *group = self.assetGroups[index];
        imageCollectionVC.assetsGroup = group;
    }
    [self.navigationController pushViewController:imageCollectionVC animated:animated];
}

#pragma mark -
#pragma mark - getter methods
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
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
