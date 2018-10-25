//
//  LLYViewWatermarkViewController.m
//  LLYGPUImageDemo
//
//  Created by lly on 2018/10/25.
//  Copyright © 2018年 lly. All rights reserved.
//

#import "LLYViewWatermarkViewController.h"
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface LLYViewWatermarkViewController ()

@property (nonatomic, strong) GPUImageMovie *movieFile;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) GPUImageMovieWriter *movieWrite;
@property (nonatomic, strong) GPUImageView *filterView;

@end

@implementation LLYViewWatermarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.filterView = [[GPUImageView alloc]initWithFrame:self.view.frame];
    self.view = self.filterView;
    
    self.filter = [[GPUImageDissolveBlendFilter alloc]init];
    [((GPUImageDissolveBlendFilter *)self.filter) setMix:0.5];
    
    NSURL *sampleUrl = [[NSBundle mainBundle] URLForResource:@"abc" withExtension:@"mp4"];
    AVAsset *asset = [AVAsset assetWithURL:sampleUrl];
    self.movieFile = [[GPUImageMovie alloc]initWithAsset:asset];
    self.movieFile.runBenchmark = YES;
    self.movieFile.playAtActualSpeed = YES;
    
    CGSize size = self.view.bounds.size;

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
    label.text = @"LLYGPUImageDemo";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor redColor];
    
    UIImage *image = [UIImage imageNamed:@"watermark.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center = CGPointMake(size.width/2, size.height/2);
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    subView.backgroundColor = [UIColor clearColor];
    
    [subView addSubview:label];
    [subView addSubview:imageView];
    
    GPUImageUIElement *uielement = [[GPUImageUIElement alloc] initWithView:subView];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *saveUrl = [NSURL fileURLWithPath:pathToMovie];
    
    self.movieWrite = [[GPUImageMovieWriter alloc]initWithMovieURL:saveUrl size:CGSizeMake(640.0, 480.0)];
    
    GPUImageFilter *progressFilter = [[GPUImageFilter alloc]init];
    [self.movieFile addTarget:progressFilter];
    [progressFilter addTarget:self.filter];
    [uielement addTarget:self.filter];
    
    self.movieWrite.shouldPassthroughAudio = YES;
    self.movieFile.audioEncodingTarget = self.movieWrite;
    [self.movieFile enableSynchronizedEncodingUsingMovieWriter:self.movieWrite];
    
    
    [self.filter addTarget:self.movieWrite];
    [self.filter addTarget:self.filterView];
    
    [self.movieWrite startRecording];
    [self.movieFile startProcessing];
    
    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        CGRect frame = imageView.frame;
        frame.origin.x += 1;
        frame.origin.y += 1;
        imageView.frame = frame;
        [uielement updateWithTimestamp:time];
    }];
    
    __weak typeof(self) weakSelf = self;

    [self.movieWrite setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        
        [strongSelf.movieWrite finishRecording];
        [progressFilter endProcessing];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:saveUrl completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{

                     if (error) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     } else {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 });
             }];
        }
        else {
            NSLog(@"error mssg)");
        }
    }];
}

@end
