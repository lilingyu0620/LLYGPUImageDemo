//
//  LLYUseCameraViewController.m
//  LLYGPUImageDemo
//
//  Created by lly on 2018/8/29.
//  Copyright © 2018年 lly. All rights reserved.
//

#import "LLYUseCameraViewController.h"
#import <GPUImage/GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface LLYUseCameraViewController ()

@property (nonatomic, strong) GPUImageView *mGPUImageView;
@property (nonatomic, strong) GPUImageVideoCamera *mGPUVideoCamera;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageTiltShiftFilter *mFilter;

@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, assign) BOOL isRecord;
@property (nonatomic, copy) NSString *pathToMovie;
@end

@implementation LLYUseCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mGPUImageView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    self.mGPUImageView.fillMode = kGPUImageFillModeStretch;
    [self.view addSubview:self.mGPUImageView];
    
    [self.view addSubview:self.recordBtn];
    self.recordBtn.center = CGPointMake(self.view.center.x, self.view.center.y-200);
    
    
    self.pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([_pathToMovie UTF8String]);
    self.movieURL = [NSURL fileURLWithPath:self.pathToMovie];
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:self.movieURL size:CGSizeMake(720, 1280)];
    //黑白滤镜
//    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc]init];
    //模糊滤镜
    self.mFilter = [[GPUImageTiltShiftFilter alloc]init];
    [self.mFilter addTarget:self.mGPUImageView];
    [self.mFilter addTarget:self.movieWriter];
    
    self.mGPUVideoCamera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.mGPUVideoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.mGPUVideoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    self.mGPUVideoCamera.audioEncodingTarget = self.movieWriter;
    self.movieWriter.encodingLiveVideo = YES;


    [self.mGPUVideoCamera addTarget:self.mFilter];
    
    //开启摄像头
    [self.mGPUVideoCamera startCameraCapture];
    
}

- (UIButton *)recordBtn{
    
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setFrame:CGRectMake(0, 0, 100, 50)];
        [_recordBtn setBackgroundColor:[UIColor redColor]];
        [_recordBtn setTitle:@"开始录制" forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(recordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
    
}

- (void)recordBtnClicked:(UIButton *)sender{
    
    if (self.isRecord) {
        self.isRecord = NO;
        [_recordBtn setTitle:@"开始录制" forState:UIControlStateNormal];
        
        [_movieWriter finishRecording];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.pathToMovie)){
            [library writeVideoAtPathToSavedPhotosAlbum:self.movieURL completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 
                 [self resetWriter];

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
    }
    else{
        self.isRecord = YES;
        [_recordBtn setTitle:@"结束录制" forState:UIControlStateNormal];
        
        //开始录制
        [_movieWriter startRecording];
    }
    
}

//解决不能连续录制视频的bug
- (void)resetWriter{
    
    [self.mFilter removeTarget:self.movieWriter];
    [[NSFileManager defaultManager] removeItemAtURL:self.movieURL error:nil];
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:self.movieURL size:CGSizeMake(720, 1280)];
    self.movieWriter.encodingLiveVideo = YES;
    
    [self.mFilter addTarget:self.movieWriter];
    
    self.mGPUVideoCamera.audioEncodingTarget = self.movieWriter;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
