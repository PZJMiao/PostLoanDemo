//
//  TakePictureVC.m
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/9.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import "TakePictureVC.h"
#import "AddCell.h"
#import "TakePictureCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "LLImagePickerController.h"
#import "LLCameraViewController.h"
#import "PHImageModel.h"
#import "LLImageBrowserController.h"

static NSString* const TYPE_TAKEPICTURE = @"TakePictureCell";
static NSString* const TYPE_ADDCELL = @"AddCell";

@interface TakePictureVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TakePictureCellDelegate>
{
    NSInteger pictureNum;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *assetDataArray;

@end

@implementation TakePictureVC
#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拍照";
    self.dataArray = [[NSMutableArray alloc] init];
    self.assetDataArray = [[NSMutableArray alloc] init];
    [self initViews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - privateMethods               - Method -
- (void)initViews
{
    self.view.backgroundColor = COLORBACKGROUND;
    [self.view addSubview:self.collectionView];
    UINib *takePictureNib = [UINib nibWithNibName:TYPE_TAKEPICTURE bundle:nil];
    [self.collectionView registerNib:takePictureNib forCellWithReuseIdentifier:TYPE_TAKEPICTURE];
    UINib *addNib = [UINib nibWithNibName:TYPE_ADDCELL bundle:nil];
    [self.collectionView registerNib:addNib forCellWithReuseIdentifier:TYPE_ADDCELL];
    pictureNum = 4;
}

- (NSString *)getViewType:(NSInteger)section row:(NSInteger)row
{
    if (self.dataArray.count<pictureNum) {
        if (row ==self.dataArray.count) {
            return TYPE_ADDCELL;
        }else{
            return TYPE_TAKEPICTURE;
        }
    }else{
        return TYPE_TAKEPICTURE;
    }
  
}
- (NSInteger)getItemCount:(NSInteger)row
{
    NSString *viewType = [self getViewType:0 row:row];
    if (viewType == TYPE_TAKEPICTURE) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}
- (CGSize) getItemSize:(NSIndexPath *)indexPath{
    CGFloat w=((SCREEN_WIDTH-10)/3.0f)-5;
    CGFloat h=w;
    return CGSizeMake(w, h);
}

- (void)takePhotoClick
{
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        NSLog(@"未获得授权使用摄像头。。。。。。在设置中打开权限");
        
    }else if (authStatus == AVAuthorizationStatusAuthorized){//有权限访问
        NSLog(@"Authorized");
        [self photoMethod];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){//第一次还未有权限访问
        NSLog(@"");
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (granted) {
                NSLog(@"Granted access to %@", mediaType);//同意拍照
                [self photoMethod];
            }else{
                NSLog(@"Not granted access to %@", mediaType);//不同意
            }
        }];
    }else{
        NSLog(@"Unknown authorization status");
    }
}

- (void)photoMethod
{
    if (self.dataArray.count>=pictureNum) {
        NSLog(@"您选择的图片数量已达到上限");
        return;
    }
    UIActionSheet * myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    [myActionSheet showInView:self.view];
}

- (void)chosePhotosMethod
{
    LLImagePickerController *imagePickerVC = [[LLImagePickerController alloc] initWithType:1];
    imagePickerVC.autoJumpToPhotoSelectPage = YES;
    imagePickerVC.allowSelectReturnType =YES;
    imagePickerVC.maxSelectedCount = pictureNum-self.dataArray.count;
 //选择照片
    if (iOS8Upwards) {
        [imagePickerVC getSelectedPHAssetsWithBlock:^(NSMutableArray<PHImageModel *> *imageArray, NSArray<PHAsset *> *assetsArray) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:imageArray];
            [self.dataArray addObjectsFromArray:array];
            [self.assetDataArray addObjectsFromArray:assetsArray];
            [self.collectionView reloadData];
        }];
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
- (void)takePhotosMothod
{
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //拍照
        LLCameraViewController *cameraVC = [[LLCameraViewController alloc] init];
        cameraVC.cameraType = CameraTypeImage;
        [cameraVC getResultFromCameraWithBlock:^(PHImageModel *imageModel, PHAsset *phAsset) {
            [self.dataArray addObject:imageModel];
            [self.assetDataArray addObject:phAsset];
            [self.collectionView reloadData];
        }];
        [self presentViewController:cameraVC animated:YES completion:nil];
        
    }else{
        //弹框提示，暂时只log输出
        NSLog(@"您的设备没有摄像头");
    }
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)delPhotoOrVideoMethod:(PHImageModel *)model
{
    if (self.dataArray.count>0) {
        [self.dataArray removeObject:model];
        [self.assetDataArray removeObject:model.phasset];
        [self.collectionView reloadData];
    }
}

#pragma mark - objective-cDelegate          - Method -
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArray.count < pictureNum) {
        return self.dataArray.count+1;
    }else{
        return self.dataArray.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *viewType = [self getViewType:indexPath.section row:indexPath.row];
    if (viewType == TYPE_TAKEPICTURE) {
        TakePictureCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TYPE_TAKEPICTURE forIndexPath:indexPath];
        if (self.dataArray.count>0) {
            //照片
            PHImageModel *model = self.dataArray[indexPath.row];
            cell.model = model;
        }
        cell.delegate = self;
        return cell;
    }else{
        AddCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TYPE_ADDCELL forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath//定义每个Item 的大小
{
    return [self getItemSize:indexPath];
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section//定义每个UICollectionView 的 margin
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{//cell之间的行间距
    return 5;
}
#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *viewType = [self getViewType:indexPath.section row:indexPath.row];
    if (viewType == TYPE_TAKEPICTURE) {
        NSLog(@"选择拍摄好的图片  select  index = %ld ",(long)indexPath.row);
        if (self.dataArray.count>0) {
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
            LLImageBrowserController *browserVC = [[LLImageBrowserController alloc] init];
            browserVC.pickerType = 1;
            browserVC.phAssetsArray = self.assetDataArray;
            browserVC.isOnlyBrowse = YES;
            browserVC.index = indexPath.row;
            [self.navigationController pushViewController:browserVC animated:YES];
        }
    }else{
        NSLog(@"select addCell index = %ld ",(long)indexPath.row);
        [self takePhotoClick];
    }
}
#pragma mark -   选择照片事件
#pragma mark -   选择器 协议方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            {
                NSLog(@"从相册选择");
                [self chosePhotosMethod];
            }
            break;
        case 1:
        {
            NSLog(@"拍照");
            [self takePhotosMothod];
        }
            break;
        default:
            break;
    }
}

#pragma mark - getters and setters          - Method -
- (UICollectionView *) collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.bounces = YES;
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.backgroundColor = COLORBACKGROUND;
    }
    return _collectionView;
}

@end
