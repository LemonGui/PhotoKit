//
//  PhotoCatcherManager.h
//  PhotoKitDemo
//
//  Created by Lemon on 2016/11/16.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@interface PhotoCatcherManager : NSObject

+ (instancetype)sharedInstance;

/*
 *    获取全部相册
 */
-(NSMutableArray<PHAssetCollection*> *)getPhotoListDatas;


/*
 *    获取某一个相册的结果集
 */
-(PHFetchResult<PHAsset *> *)getFetchResult:(PHAssetCollection *)assetCollection ascend:(BOOL)ascend;

/*
 *    获取某一个相册的结果集
 */
+ (PHFetchResult<PHAsset *> *)getFetchResultWithMediaType:(PHAssetMediaType)mediaType ascend:(BOOL)ascend;


/*
 *    获取图片实体，并把图片结果存放到数组中，返回值数组
 */
-(NSMutableArray<PHAsset*> *)getPhotoAssets:(PHFetchResult *)fetchResult;


/*
 *    只获取相机胶卷结果集,按时间排序
 */
-(PHFetchResult<PHAsset *> *)getCameraRollFetchResulWithAscend:(BOOL)ascend;


/*
 *    同时获取多张图片(高清)，全部为高清图resultHandler才执行，需要从iCloud下载时progressHandler提供每张进度
 */
-(void)getImagesForAssets:(NSArray<PHAsset *> *)assets progressHandler:(void(^)(double progress, NSError * error, BOOL *stop, NSDictionary * info))progressHandler resultHandler:(void (^)(NSArray<NSDictionary *>* result))resultHandler;


/*
 *    获取单张高清图,progressHandler从iCloud下载进度
 */
-(void)getImageHighQualityForAsset:(PHAsset *)asset progressHandler:(void(^)(double progress, NSError * error, BOOL *stop, NSDictionary * info))progressHandler resultHandler:(void (^)(UIImage* result, NSDictionary * info))resultHandler;

/*
 *    获取单张缩略图
 */
-(void)getImageLowQualityForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage* result, NSDictionary * info))resultHandler;

/*
 *    获取相册是否授权
 */
+(void)requestAuthorizationHandler:(void(^)(BOOL isAuthorized))handler;

@end

