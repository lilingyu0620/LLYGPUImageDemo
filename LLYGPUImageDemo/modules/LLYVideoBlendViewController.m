//
//  LLYVideoBlendViewController.m
//  LLYGPUImageDemo
//
//  Created by lly on 2019/12/30.
//  Copyright © 2019 lly. All rights reserved.
//

#import "LLYVideoBlendViewController.h"
#import "GPUImage.h"
#import "LLYGPUImageVideoAlphaFilter.h"

@interface LLYVideoBlendViewController ()<GPUImageMovieDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) GPUImageMovie *movie;
@property (nonatomic, strong) LLYGPUImageVideoAlphaFilter *filter;
@property (nonatomic, strong) GPUImageView *filterView;

@end

@implementation LLYVideoBlendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageView.image = [UIImage imageNamed:@"wk.JPG"];
    [self.view addSubview:self.imageView];
    
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.filterView.center = self.view.center;
    self.filterView.contentMode = UIViewContentModeScaleAspectFill;
    self.filterView.fillMode = kGPUImageFillModeStretch;
    self.filterView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.filterView];
    
    [self playVideo];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_movie endProcessing];
}


/**
 播放视频，实时添加滤镜
 */
- (void)playVideo{
    
    NSURL *sampleURL = [[NSBundle mainBundle]URLForResource:@"rosetest1" withExtension:@"mp4" subdirectory:nil];
    
    /**
     *  初始化 movie
     */
    _movie = [[GPUImageMovie alloc] initWithURL:sampleURL];
    
    /**
     *  是否重复播放
     */
    _movie.shouldRepeat = YES;
    
    /**
     *  控制GPUImageView预览视频时的速度是否要保持真实的速度。
     *  如果设为NO，则会将视频的所有帧无间隔渲染，导致速度非常快。
     *  设为YES，则会根据视频本身时长计算出每帧的时间间隔，然后每渲染一帧，就sleep一个时间间隔，从而达到正常的播放速度。
     */
    _movie.playAtActualSpeed = YES;
    
    /**
     *  设置代理 GPUImageMovieDelegate，只有一个方法 didCompletePlayingMovie
     */
    _movie.delegate = self;
    
    /**
     *  This enables the benchmarking mode, which logs out instantaneous and average frame times to the console
     *
     *  这使当前视频处于基准测试的模式，记录并输出瞬时和平均帧时间到控制台
     *
     *  每隔一段时间打印： Current frame time : 51.256001 ms，直到播放或加滤镜等操作完毕
     */
    _movie.runBenchmark = YES;
    
    /**
     *  添加Doki滤镜
     */
    _filter = [[LLYGPUImageVideoAlphaFilter alloc]init];

    [_movie addTarget:_filter];
    
    /**
     *  添加显示视图
     */
    [self.view addSubview:_filterView];
    
    [_filter addTarget:self.filterView];
    
    [_movie startProcessing];
    
}

#pragma mark - GPU Delegate

- (void)didCompletePlayingMovie{}

@end
