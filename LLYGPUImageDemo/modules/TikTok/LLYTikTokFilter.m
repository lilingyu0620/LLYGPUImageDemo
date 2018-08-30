//
//  LLYTikTokFilter.m
//  LLYGPUImageDemo
//
//  Created by lly on 2018/8/30.
//  Copyright © 2018年 lly. All rights reserved.
//

#import "LLYTikTokFilter.h"

NSString *const kGPUImage3DFragmentShaderString = SHADER_STRING
(
 // 图片的像素坐标
 varying highp vec2 textureCoordinate;
 // 图片
 uniform sampler2D inputImageTexture;
 
 uniform lowp vec2 imagePixel;
 
 uniform highp vec2 offset;
 
 void main()
 {
     // 对纹理坐标进行偏移，*5.0代表着偏移五个像素
     lowp vec4 right = texture2D(inputImageTexture, textureCoordinate + imagePixel * offset);
     lowp vec4 left = texture2D(inputImageTexture, textureCoordinate - imagePixel * offset);
     // 最终取left的r跟right的gb组成一个新的像素
     gl_FragColor = vec4(left.r,right.g,right.b,1.0);
 }
);

@implementation LLYTikTokFilter

- (instancetype)init{
    self = [super initWithFragmentShaderFromString:kGPUImage3DFragmentShaderString];
    if (self) {
        
    }
    return self;
}

- (void)setupFilterForSize:(CGSize)filterFrameSize
{
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext setActiveShaderProgram:filterProgram];
//        GPUVector3 imagePixel;
//        imagePixel.one = 1.0 / filterFrameSize.width;
//        imagePixel.two = 1.0 / filterFrameSize.height;
        // 这里是向着色器传递每个像素格式化成0~1的值
//        [self setFloatVec2:imagePixel forUniformName:@"imagePixel"];
        CGSize imagePixel;
        imagePixel.width = 1.0 / filterFrameSize.width;
        imagePixel.height = 1.0 / filterFrameSize.height;
        [self setSize:imagePixel forUniformName:@"imagePixel"];
        // 传递偏移值数据
        [self setPoint:self.offset forUniformName:@"offset"];
    });
}
// GPUImage的作者不知道出于什么目的没有写setFloatVec2:forUniformName:函数，我这边依照setFloatVec3:forUniformName:写了一个
- (void)setFloatVec2:(GPUVector3)newVec2 forUniformName:(NSString *)uniformName;
{
    
    GLint uniformIndex = [filterProgram uniformIndex:uniformName];
    [self setVec2:newVec2 forUniform:uniformIndex program:filterProgram];
}

- (void)setVec2:(GPUVector3)vectorValue forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;
{
    runAsynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext setActiveShaderProgram:shaderProgram];
        
        [self setAndExecuteUniformStateCallbackAtIndex:uniform forProgram:shaderProgram toBlock:^{
            glUniform2fv(uniform, 1, (const GLfloat *)&vectorValue);
        }];
    });
}
@end
