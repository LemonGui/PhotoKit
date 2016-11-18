//
//  PhotoCell.m
//  PhotoKitDemo
//
//  Created by Lemon on 2016/11/15.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;


@end

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBtn.selected = NO;
}


-(void)setImage:(UIImage *)image{
    _image = image;
    _cellImageView.image = image;
}

- (IBAction)selectedBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
    
}


@end
