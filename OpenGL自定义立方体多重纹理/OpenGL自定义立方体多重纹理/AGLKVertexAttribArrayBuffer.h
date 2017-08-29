//
//  AGLKVertexAttribArrayBuffer.h
//  OpenGLES 2
//
//  Created by liuyang on 2017/8/2.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class AGLKElementIndexArrayBuffer;

typedef enum {
    AGLKVertexAttribPosition = GLKVertexAttribPosition,
    AGLKVertexAttribNormal = GLKVertexAttribNormal,
    AGLKVertexAttribColor = GLKVertexAttribColor,
    AGLKVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    AGLKVertexAttribTexCoord1 = GLKVertexAttribTexCoord1,
}AGLKVertexAttrib;


@interface AGLKVertexAttribArrayBuffer : NSObject
{
    GLsizeiptr   stride;
    GLsizeiptr   bufferSizeBytes;
    GLuint       name;
}

@property (nonatomic, readonly) GLuint
name;
@property (nonatomic, readonly) GLsizeiptr
bufferSizeBytes;
@property (nonatomic, readonly) GLsizeiptr
stride;

+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count;

- (id)initWithAttribStride:(GLsizeiptr)stride
          numberOfVertices:(GLsizei)count
                     bytes:(const GLvoid *)dataPtr
                     usage:(GLenum)usage;

- (void)reinitWithAttribStride:(GLsizeiptr)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr;

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;

@end
