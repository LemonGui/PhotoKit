//
//  ViewController.m
//  PhotoKitDemo
//
//  Created by Lemon on 2016/11/15.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import "ViewController.h"
#import "PhotoController.h"
#import "UIImage+Utility.h"
#import "Constant.h"
#define APPCONFIG_UI_SCREEN_FWIDTH        ([UIScreen mainScreen].bounds.size.width)
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong) UIImage * lastImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(enterPhotoAlbum)];
}

-(void)enterPhotoAlbum{
    PhotoController * vc = [PhotoController new];
       __weak typeof(self) __weakMe = self;
    vc.photoCallBackBlock = ^(NSArray * photos){
        for (NSDictionary * dic in photos) {
            UIImage * image = dic[EEPhotoImage];
            NSUInteger location = __weakMe.textView.selectedRange.location ;
            NSTextAttachment * attachMent = [[NSTextAttachment alloc] init];
            attachMent.image = image;
            CGSize size = [__weakMe displaySizeWithImage:image];
            attachMent.bounds = CGRectMake(0, 0, size.width,size.height);
            NSAttributedString * attStr = [NSAttributedString attributedStringWithAttachment:attachMent];
            NSMutableAttributedString *textViewString = [self.textView.attributedText mutableCopy];
            [textViewString insertAttributedString:attStr atIndex:location];
            
            [textViewString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:NSMakeRange(0, textViewString.length)];
            __weakMe.textView.attributedText = textViewString;
            __weakMe.textView.selectedRange = NSMakeRange(location + 1,0);
        }
       
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//显示图片的大小 （全屏）
- (CGSize)displaySizeWithImage:(UIImage *)image {
    CGSize displaySize;
    if (image.size.width !=0 ) {
        CGFloat _widthRadio = APPCONFIG_UI_SCREEN_FWIDTH / image.size.width;
        CGFloat _imageHeight = image.size.height * _widthRadio;
        displaySize = CGSizeMake(APPCONFIG_UI_SCREEN_FWIDTH, _imageHeight);
    }else{
        displaySize = CGSizeZero;
    }
    return displaySize;
}


@end
