uniform sampler2D texture;
uniform mediump float sharpen;


varying mediump vec2 fragmentTextureCoordinate;
varying mediump vec2 leftTextureCoordinate;
varying mediump vec2 rightTextureCoordinate;

varying mediump vec2 topTextureCoordinate;
varying mediump vec2 topLeftTextureCoordinate;
varying mediump vec2 topRightTextureCoordinate;

varying mediump vec2 bottomTextureCoordinate;
varying mediump vec2 bottomLeftTextureCoordinate;
varying mediump vec2 bottomRightTextureCoordinate;


void main()
{
    mediump vec3  topLeftColor = texture2D(texture,topLeftTextureCoordinate).rgb;
    mediump vec3  topColor = texture2D(texture,topTextureCoordinate).rgb;
    mediump vec3  topRightColor = texture2D(texture,topRightTextureCoordinate).rgb;
    
    mediump vec3  leftColor = texture2D(texture,leftTextureCoordinate).rgb;
    mediump vec3  centerColor = texture2D(texture,fragmentTextureCoordinate).rgb;
    mediump vec3  rightColor = texture2D(texture,rightTextureCoordinate).rgb;
    
    mediump vec3  bottomLeftColor = texture2D(texture,bottomLeftTextureCoordinate).rgb;
    mediump vec3  bottomColor = texture2D(texture,bottomTextureCoordinate).rgb;
    mediump vec3  bottomRightColor = texture2D(texture,bottomRightTextureCoordinate).rgb;
    
    
    mediump vec3 blurredPixel = (topLeftColor    + topColor       + topRightColor +
                                 leftColor       + centerColor    + rightColor    +
                                 bottomLeftColor + bottomColor    + bottomRightColor)/9.0;
    
    gl_FragColor = vec4(blurredPixel,1);
}