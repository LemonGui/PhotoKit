//
//  PhotoCell.h
//  PhotoKitDemo
//
//  Created by Lemon on 2016/11/15.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell
@property(nonatomic,strong) UIImage * image;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property(nonatomic,copy) void(^(btnClickBlock))(UIButton * selectedBtn);
@end
