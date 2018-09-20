//
//  LLYMovieWatermarkViewController.m
//  LLYGPUImageDemo
//
//  Created by lly on 2018/9/20.
//  Copyright © 2018年 lly. All rights reserved.
//

#import "LLYMovieWatermarkViewController.h"
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface LLYMovieWatermarkViewController ()

@property (nonatomic, strong) GPUImageMovie *movieFile;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) GPUImageMovieWriter *movieWrite;
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *filterView;

@end

@implementation LLYMovieWatermarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.filterView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    self.view = self.filterView;
    
}

@end
