//
//  PhotoController.h
//  PhotoKitDemo
//
//  Created by Lemon on 2016/11/15.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoController : UIViewController
@property (nonatomic,copy) void(^(photoCallBackBlock))(NSArray *);
@end
