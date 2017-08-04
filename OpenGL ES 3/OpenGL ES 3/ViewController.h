//
//  ViewController.h
//  OpenGL ES 3
//
//  Created by liuyang on 2017/8/3.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (strong, nonatomic) GLKBaseEffect
*baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
*vertexBuffer;

@end
