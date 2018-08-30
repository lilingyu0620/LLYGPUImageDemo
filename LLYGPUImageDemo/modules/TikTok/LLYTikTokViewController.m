//
//  LLYTikTokViewController.m
//  LLYGPUImageDemo
//
//  Created by lly on 2018/8/30.
//  Copyright © 2018年 lly. All rights reserved.
//

#import "LLYTikTokViewController.h"
#import "LLYTikTokFilter.h"
#import <GPUImage.h>

@interface LLYTikTokViewController ()

@property (nonatomic, strong) GPUImageView *mGPUImageView;
@property (nonatomic, strong) GPUImagePicture *mGPUPicture;
@property (nonatomic, strong) LLYTikTokFilter *tiktokfilter;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation LLYTikTokViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mGPUImageView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    self.mGPUImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:self.mGPUImageView];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    UIImage *image = [UIImage imageNamed:@"wk.JPG"];
    // 初始化一个GPUImagePicture
    // GPUImagePicture是一个GPUImage的输出源(GPUImageOutput)
    self.mGPUPicture  = [[GPUImagePicture alloc] initWithImage:image];
    
    // 使用我们自定义的3D滤镜
    self.tiktokfilter = [[LLYTikTokFilter alloc] init];
    // 告诉GPUImageFilter我们传输的下一帧数据是来自Image
    [self.tiktokfilter useNextFrameForImageCapture];
    
    // picture添加他的输出目标
    [self.tiktokfilter addTarget:self.mGPUImageView];
    [self.mGPUPicture addTarget:self.tiktokfilter];
    
}

- (void)update{
    
    // 每次随机产生一个0~10的数进行动画
    int x = arc4random() % 11;
    int y = arc4random() % 11;
    
    self.tiktokfilter.offset = CGPointMake(x, y);
    [self.mGPUPicture processImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
