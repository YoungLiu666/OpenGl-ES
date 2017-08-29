//
//  ViewController.m
//  OpenGL ES 3
//
//  Created by liuyang on 2017/8/3.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize baseEffect;
@synthesize vertexBuffer;

typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

static const SceneVertex vertices[] =
{
 //xyz 支持点，线，三角形   纹理坐标  st（uv坐标映射到st轴上）纹理坐标范围(0.0 1.0) 顶点（-1 1）
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化上下文
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    view.context = [[AGLKContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [AGLKContext setCurrentContext:view.context];
    
   //创建着色器GLKBaseEffect
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha

    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f, // Red
                                                              0.0f, // Green
                                                              0.0f, // Blue
                                                              1.0f);// Alpha
    //AGLKVertexAttribArrayBuffer自定义类，完成
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         bytes:vertices
                         usage:GL_STATIC_DRAW];
    
    
    CGImageRef imageRef0 =
    [[UIImage imageNamed:@"花.png"] CGImage];
    //GLKTextureLoader 会自动 用 glTexParameteri() 方法来为创建的纹理缓存设置 OpenGL ES 取样和循环模式
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader
                                    textureWithCGImage:imageRef0
                                    options:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [NSNumber numberWithBool:YES],
                                             GLKTextureLoaderOriginBottomLeft, nil]
                                    error:NULL];
    
    //把纹理赋值给着色器
    self.baseEffect.texture2d0.name = textureInfo0.name;
    self.baseEffect.texture2d0.target = textureInfo0.target;
    
    
    CGImageRef imageRef1 = 
    [[UIImage imageNamed:@"蜜蜂.png"] CGImage];
    
    GLKTextureInfo *textureInfo1 = [GLKTextureLoader 
                                    textureWithCGImage:imageRef1 
                                    options:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [NSNumber numberWithBool:YES], 
                                             GLKTextureLoaderOriginBottomLeft, nil] 
                                    error:NULL];
    
    //多重纹理baseEffext的第二个纹理属性texture2D1被设置为使用GLKTextureEnvModeDecal模式，这种模式会使用一个与glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)类似的方程式来混合第二个与第一个纹理。
    self.baseEffect.texture2d1.name = textureInfo1.name;
    self.baseEffect.texture2d1.target = textureInfo1.target;
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;
}

//  GLKView 类的委托方法。每当一个 GLKView 实例需要重绘时，它都会让保存在视图的上下文属性中的 OpenGL ES 的上下文成为当前上下文。如果需要的话，GLKView 实例会确定与一个 Core Animation 层分享的缓存，执行其他的标准 OpenGL ES 配置，并发一个消息来调用OpenGLES_Ch2_1ViewController的-glkView:drawInRect:方法。
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // 设置当前设定的帧缓存的像素颜色渲染缓存中的每一个像素的颜色为前面使用 glClearColor() 函数设定的值。 AGLKContext继承EAGLContext类
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    //启动着色器
    [self.baseEffect prepareToDraw];
    
    // sizeof()返回一个对象或者类型所占的内存字节数
    // STEP 绘图  1参数告诉 GPU 怎么处理在设定的顶点缓存内的顶点数据
    // 第二个参数和第三个参数分别指定缓存内的需要渲染的 第一个顶点的位置和需要渲染的顶点的数量
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    GLKView *view = (GLKView *)self.view;
    [AGLKContext setCurrentContext:view.context];
    
    //删除不再需要的顶点缓存和上下文
    self.vertexBuffer = nil;
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
