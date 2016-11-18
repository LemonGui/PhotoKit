//
//  PhotoBrowserView.m
//  PhotoKitDemo
//
//  Created by Lemon on 2016/11/16.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import "PhotoBrowserView.h"

@interface PhotoBrowserView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoBrowserView

+(instancetype)photoBrowserWithNib{
     return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
}

-(void)dismiss{
    self.hidden = YES;
}



@end
