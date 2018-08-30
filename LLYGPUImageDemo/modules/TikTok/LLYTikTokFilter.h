//
//  LLYTikTokFilter.h
//  LLYGPUImageDemo
//
//  Created by lly on 2018/8/30.
//  Copyright © 2018年 lly. All rights reserved.
//

#import "GPUImageColorInvertFilter.h"

@interface LLYTikTokFilter : GPUImageColorInvertFilter

/**
 3d滤镜偏移值
 */
@property (nonatomic, assign) CGPoint offset;

@end
