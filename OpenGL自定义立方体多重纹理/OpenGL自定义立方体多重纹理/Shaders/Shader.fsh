//
//  Shader.fsh
//
//


//uniform 给顶点着色齐和片段着色器赋值的，
uniform sampler2D uSampler0;
uniform sampler2D uSampler1;

//varying 限定符，用于传递顶点着色器的值给片断着色器。lowp表示低精确度 4个浮点数的矢量 vColor 接收vshader中的值;
varying lowp vec4 vColor;
varying lowp vec2 vTextureCoord0;
varying lowp vec2 vTextureCoord1;


void main()
{
    // 从纹理单元获得采样的颜色0和1。.
    lowp vec4 color0 = texture2D(uSampler0, vTextureCoord0);
    lowp vec4 color1 = texture2D(uSampler1, vTextureCoord1);
    
    // 混合两采样的颜色使用texcolor1的alpha分量然后乘以光的颜色.
    gl_FragColor = mix(color0, color1, color1.a) * vColor;
}
