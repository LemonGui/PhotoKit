//
//  PhotoController.m
//  PhotoKitDemo
//
//  Created by Lemon on 2016/11/15.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import "PhotoController.h"
#import "PhotoCell.h"
#import "PhotoCatcherManager.h"
#import "PhotoBrowserView.h"
#define MARGIN 3

static CGSize ImageSize;
@interface PhotoController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic,strong) PHFetchResult * allPhotos;
@property (nonatomic,strong) PhotoCatcherManager * manager;
@property (nonatomic,strong) NSMutableArray * selectedArray;
@property (nonatomic,strong) PhotoBrowserView * browserView;
@property (nonatomic,weak) MBProgressHUD * hud;
@end

@implementation PhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavi];
    [self initContentView];

    self.selectedArray = [NSMutableArray array];
    self.manager = [PhotoCatcherManager sharedInstance];
    self.allPhotos = [PhotoCatcherManager getFetchResultWithMediaType:PHAssetMediaTypeImage ascend:NO];
}

-(void)initContentView{
    UICollectionViewFlowLayout * flowLayout =(UICollectionViewFlowLayout *) self.photoCollectionView.collectionViewLayout;
    flowLayout.minimumLineSpacing = MARGIN;
    flowLayout.minimumInteritemSpacing = MARGIN;
    CGFloat itemWidth = (self.view.frame.size.width - 5*MARGIN)/4;
    ImageSize = CGSizeMake(itemWidth*1.5, itemWidth*1.5);
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, MARGIN,0, MARGIN);
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    _browserView = [PhotoBrowserView photoBrowserWithNib];
    _browserView.frame = self.view.bounds;
    _browserView.hidden = YES;
    [self.view addSubview:_browserView];
    
    _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    _hud.hidden = YES;
}

-(void)initNavi{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishSelected)];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectedBtn.selected = NO;
    for (NSIndexPath * index in _selectedArray) {
        if (index.row == indexPath.row) {
            cell.selectedBtn.selected = YES;
        }
    }
    
    PHAsset *asset = self.allPhotos[indexPath.item];
    
    WS(weakSelf);
    [cell setBtnClickBlock:^(UIButton * btn) {
        if (btn.selected) {
            if (weakSelf.selectedArray.count>=20) {
              MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"本次最多选择20张照片";
                [hud hideAnimated:YES afterDelay:2];
                btn.selected = NO;
                return ;
            }
            [weakSelf.selectedArray addObject:indexPath];
        }else{
            [weakSelf.selectedArray removeObject:indexPath];
        }
    }];
    
#pragma mark 单张缩略图
    [_manager getImageLowQualityForAsset:asset targetSize:ImageSize resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            cell.image = result;
        }
    }];
    
    return cell;
}

#pragma mark- 单张图片
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PHAsset *asset = self.allPhotos[indexPath.item];
    WS(weakSelf);
    [_manager getImageHighQualityForAsset:asset progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (error) {
            NSLog(@"iClound error:  %@ ",error);
            return ;
        }
        _hud.hidden = NO;
        _hud.progress = progress;
        _hud.label.text = @"同步iCloud中";
        NSLog(@"downloading the image from iCloud, progress:~~ %f ~~%@",progress,info);
        
    }  resultHandler:^(UIImage *result, NSDictionary *info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (downloadFinined) {
            [weakSelf.hud setHidden:YES];
        }
        weakSelf.browserView.image = result;
        weakSelf.browserView.hidden = NO;
    }];
    
}

#pragma mark- 选取多张图片
-(void)finishSelected{
    
    NSMutableArray * assets = [NSMutableArray array];
    WS(weakSelf);
    for (NSIndexPath * indexPath in _selectedArray) {
        PHAsset * asset = self.allPhotos[indexPath.item];
        [assets addObject:asset];
    }

    [_manager getImagesForAssets:assets progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (error) {
            NSLog(@"iClound error:  %@ ",error);
            return ;
        }
                weakSelf.hud.hidden = NO;
                weakSelf.hud.progress = progress;
                weakSelf.hud.label.text = @"同步iCloud中";
        NSLog(@"downloading the image from iCloud, progress:~~ %f ~~%@",progress,info);
        
    } resultHandler:^(NSArray<NSDictionary *> *result) {
        weakSelf.hud.hidden = YES;
        [weakSelf.navigationController popViewControllerAnimated:YES];
        weakSelf.photoCallBackBlock(result);
        
    }];
}


@end
