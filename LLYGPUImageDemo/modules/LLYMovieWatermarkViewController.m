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
    
    self.filter = [[GPUImageDissolveBlendFilter alloc]init];
    [((GPUImageDissolveBlendFilter *)self.filter) setMix:0.5];
    
    NSURL *sampleUrl = [[NSBundle mainBundle] URLForResource:@"rosebg" withExtension:@"mp4"];
    self.movieFile = [[GPUImageMovie alloc]initWithURL:sampleUrl];
    self.movieFile.runBenchmark = YES;
    self.movieFile.playAtActualSpeed = YES;
    
    self.videoCamera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *savePath = [NSURL fileURLWithPath:pathToMovie];
    
    self.movieWrite = [[GPUImageMovieWriter alloc]initWithMovieURL:savePath size:CGSizeMake(640, 480)];
    [self.videoCamera addTarget:self.filter];
    [self.movieFile addTarget:self.filter];
    self.movieWrite.shouldPassthroughAudio = NO;
    self.videoCamera.audioEncodingTarget = self.movieWrite;
    self.movieWrite.encodingLiveVideo = NO;
    
    [self.filter addTarget:self.filterView];
    [self.filter addTarget:self.movieWrite];
    
    [self.videoCamera startCameraCapture];
    [self.movieWrite startRecording];
    [self.movieFile startProcessing];
    
    __weak typeof(self) weakSelf = self;
    [self.movieWrite setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.filter removeTarget:strongSelf.movieWrite];
        [strongSelf.movieWrite finishRecording];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:savePath completionBlock:^(NSURL *assetURL, NSError *error)
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
