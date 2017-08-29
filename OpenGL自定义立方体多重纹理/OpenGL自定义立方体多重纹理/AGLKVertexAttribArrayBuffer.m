//
//  AGLKVertexAttribArrayBuffer.m
//  OpenGLES 2
//
//  Created by liuyang on 2017/8/2.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"
@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr
bufferSizeBytes;

@property (nonatomic, assign) GLsizeiptr
stride;

@end
@implementation AGLKVertexAttribArrayBuffer
    @synthesize name;
    @synthesize bufferSizeBytes;
    @synthesize stride;
- (id)initWithAttribStride:(GLsizeiptr)aStride
          numberOfVertices:(GLsizei)count
                     bytes:(const GLvoid *)dataPtr
                     usage:(GLenum)usage;
{
    NSParameterAssert(0 < aStride);
    NSAssert((0 < count && NULL != dataPtr) ||
             (0 == count && NULL == dataPtr),
             @"data must not be NULL or count > 0");
    
    if(nil != (self = [super init]))
    {
        stride = aStride;
        bufferSizeBytes = stride * count;
        // 1.为缓存生成一个独一无二的标识符
        glGenBuffers(1,
                     &name);// 1生成的缓存标识符的数量，2.指向生成的标识符的内存保存位置
        
        //2.为接下来的运算设定缓存
        glBindBuffer(GL_ARRAY_BUFFER,
                     self.name);// 1。要确定定一种类型的缓存（两种类型） 2参数：要绑定的缓存的标识符
        //3.复制数据到缓存
        glBufferData(                                       GL_ARRAY_BUFFER,
                     bufferSizeBytes,  // 复制进这个缓存的字节的数量
                     dataPtr,          //复制的字节的地址
                     usage);           // 提示了缓存在未来的运算中可能将会怎样使用
        
        NSAssert(0 != name, @"Failed to generate name");
    }
    
    return self;
}

-(void)reinitWithAttribStride:(GLsizeiptr)aStride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr{
    NSParameterAssert(0 < aStride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != name, @"Invalid name");
    
    self.stride = aStride;
    self.bufferSizeBytes = aStride * count;
    
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW);

}

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable
{
    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != name, @"Invalid name");
    
    glBindBuffer(GL_ARRAY_BUFFER,
                 self.name);
    
    if(shouldEnable)
    {
        glEnableVertexAttribArray(     //4. 启动
                                  index);
    }
    //5.设置指针
    glVertexAttribPointer(
                          index,  //当前绑定的缓存包含每个顶点的位置信息
                          count,    // 每个位置有几个部分
                          GL_FLOAT, // 每个部分都保存为一个浮点类型的值
                          GL_FALSE,  // 小数点定数据是否可以改变
                          self.stride, // “步幅”，它指定了每个顶点的保存需要多少个字节
                          NULL + offset);      // 告诉 OpenGL ES 可以从当前绑定的顶点缓存的开始位置的顶点数据
#ifdef DEBUG
    {
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count
{
    NSAssert(self.bufferSizeBytes >=
             ((first + count) * self.stride),
             @"Attempt to draw more vertex data than available.");
     // 6.绘图
    glDrawArrays(mode, first, count); //告诉 GPU怎么处理在定的顶点缓存内的顶点数据.第二个参数和第三个参数分别指定缓存内的需要渲染的 第一个顶点的位置和需要渲染的顶点的数量
}

+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count;
{
    glDrawArrays(mode, first, count); //  6
}

- (void)dealloc
{
    // 7.删除不再需要的顶点缓存和上下文
    if (0 != name)
    {
        glDeleteBuffers (1, &name);
        name = 0;
    }
}

@end
