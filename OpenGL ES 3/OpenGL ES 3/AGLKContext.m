//
//  AGLKContext.m
//  OpenGLES 2
//
//  Created by liuyang on 2017/8/2.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext

- (void)setClearColor:(GLKVector4)clearColorRGBA
{
    clearColor = clearColorRGBA;
    
    glClearColor(
                 clearColorRGBA.r,
                 clearColorRGBA.g,
                 clearColorRGBA.b,
                 clearColorRGBA.a);
}

- (GLKVector4)clearColor
{
    return clearColor;
}

- (void)clear:(GLbitfield)mask
{
    
    glClear(mask);
}

- (void)enable:(GLenum)capability;
{
    
    glEnable(capability);
}

- (void)disable:(GLenum)capability;
{
    
    glDisable(capability);
}

- (void)setBlendSourceFunction:(GLenum)sfactor
           destinationFunction:(GLenum)dfactor;
{
    glBlendFunc(sfactor, dfactor);
}

@end
