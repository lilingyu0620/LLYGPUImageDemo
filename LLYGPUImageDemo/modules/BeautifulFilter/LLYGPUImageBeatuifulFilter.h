//
//  LLYGPUImageBeatuifulFilter.h
//  LLYGPUImageDemo
//
//  Created by lly on 2018/8/29.
//  Copyright © 2018年 lly. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import <GPUImage.h>

@class GPUImageCombinationFilter;

@interface LLYGPUImageBeatuifulFilter : GPUImageFilterGroup{
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
    GPUImageCombinationFilter *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}

@end
