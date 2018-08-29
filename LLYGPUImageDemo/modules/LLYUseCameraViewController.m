//
//  LLYUseCameraViewController.m
//  LLYGPUImageDemo
//
//  Created by lly on 2018/8/29.
//  Copyright © 2018年 lly. All rights reserved.
//

#import "LLYUseCameraViewController.h"
#import <GPUImage/GPUImage.h>


@interface LLYUseCameraViewController ()

@property (nonatomic, strong) GPUImageView *mGPUImageView;
@property (nonatomic, strong) GPUImageVideoCamera *mGPUVideoCamera;

@end

@implementation LLYUseCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mGPUImageView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    self.mGPUImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:self.mGPUImageView];
    
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc]init];
    [filter addTarget:self.mGPUImageView];
    
    self.mGPUVideoCamera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.mGPUVideoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.mGPUVideoCamera.horizontallyMirrorFrontFacingCamera = YES;
    [self.mGPUVideoCamera addTarget:filter];
    
    //开启摄像头
    [self.mGPUVideoCamera startCameraCapture];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
