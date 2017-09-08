//
//  Shader.vsh 顶点着色器
//
//

//顶点属性 attribute局部变量(只能在顶点Shader中用) Attribute 是在随着每一个顶点不同而会发生变动的输入值，例如顶点的位置和纹理坐标等。顶点着色器利用这些变量来计算位置，以它们为基础计算一些值，然后把这些值以 varyings 的方式传到片段着色器。
attribute vec4 aPosition;
attribute vec3 aNormal;
attribute vec2 aTextureCoord0;
attribute vec2 aTextureCoord1;

varying lowp vec4 vColor;
varying lowp vec2 vTextureCoord0;
varying lowp vec2 vTextureCoord1;

uniform mat4 uModelViewProjectionMatrix; 4乘4矩阵
uniform mat3 uNormalMatrix;

void main()
{
    //收集需要计算光的颜色信息
    vec3 eyeNormal = normalize(uNormalMatrix * aNormal);//标准化向量
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(0.7, 0.7, 0.7, 1.0);
    
    // 计算到最后的片段颜色光
    float nDotVP = max(0.0, dot(eyeNormal, lightPosition));
    vColor = vec4((diffuseColor * nDotVP).xyz, diffuseColor.a);
    
    // 通过两组纹理坐标的片段着色
    vTextureCoord0 = aTextureCoord0.st;
    vTextureCoord1 = aTextureCoord1.st;
    
    // 通过组合模型视图投影矩阵对传入顶点位置进行转换，以在渲染缓冲区中生成片段位置。gl_Position输出属性-变换后的顶点的位置,所有的顶点着色器都必须写这个值
    gl_Position = uModelViewProjectionMatrix * aPosition;
}
