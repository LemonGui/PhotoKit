//
//  PhotoBrowserView.h
//  PhotoKitDemo
//
//  Created by Lemon on 2016/11/16.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserView : UIView
@property (nonatomic,strong) UIImage * image;

+(instancetype)photoBrowserWithNib;

@end
