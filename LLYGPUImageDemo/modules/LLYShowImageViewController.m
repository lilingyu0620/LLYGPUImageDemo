//
//  LLYShowImageViewController.m
//  LLYGPUImageDemo
//
//  Created by lly on 2018/8/29.
//  Copyright © 2018年 lly. All rights reserved.
//

#import "LLYShowImageViewController.h"
#import <GPUImage/GPUImage.h>

@interface LLYShowImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LLYShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"显示带滤镜的图片";
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    [self.view addSubview:self.imageView];
    
    //添加一个GPUImage滤镜
    GPUImageFilter *filter = [[GPUImageSepiaFilter alloc]init];
    self.imageView.image = [filter imageByFilteringImage:[UIImage imageNamed:@"wk.JPG"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
