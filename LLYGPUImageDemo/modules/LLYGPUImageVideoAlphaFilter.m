//
//  LLYGPUImageVideoAlphaFilter.m
//  LLYGPUImageDemo
//
//  Created by lly on 2019/12/31.
//  Copyright © 2019 lly. All rights reserved.
//

#import "LLYGPUImageVideoAlphaFilter.h"

NSString *const kGPUImageVideoAlphaShaderString = SHADER_STRING
(
 
 varying highp vec2 textureCoordinate;//这个对应下面的ST坐标,即右边视频的坐标
 uniform sampler2D inputImageTexture;//这个是完整视频的纹理
 
 const lowp vec2 leftW = vec2(-0.5,0.0);
 
 void main()
 {
     //从右边的视频中拿RGB值，从左边的视频中拿Alpha值，然后返回一个新的RGBA.
     lowp vec4 rightTextureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec2 leftTextureCoordinate = leftW + textureCoordinate;
     lowp vec4 leftTextureColor = texture2D(inputImageTexture, leftTextureCoordinate);
     gl_FragColor = vec4(rightTextureColor.rgb,leftTextureColor.r);
 }
 );

@implementation LLYGPUImageVideoAlphaFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageVideoAlphaShaderString]))
    {
        return nil;
    }
    
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    
    static const GLfloat posVertices[] = {
        // x , y
        -1, 1,
        1, 1,
        -1, -1,
        1, -1,
    };
    static const GLfloat textVertices[] = {
        // s , t
        0.5, 1.0,
        1.0, 1.0,
        0.5, 0.0,
        1.0, 0.0
    };

    // 向缓冲区对象写入刚定义的顶点数据
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//    glBlendFunc(GL_ONE, GL_ZERO);
    
    [super renderToTextureWithVertices:posVertices textureCoordinates:textVertices];
    
    glDisable(GL_BLEND);
}

@end
