//
//  ViewController.h
//  OpenGL自定义立方体多重纹理
//
//  Created by liuyang on 2017/8/23.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController
{
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    GLfloat _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _texture0ID;
    GLuint _texture1ID;
}

@property (strong, nonatomic) GLKBaseEffect
*baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
*vertexBuffer;
@end

