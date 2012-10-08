//
//  Shader.fsh
//  Irritated
//
//  Created by Rounak Jain on 23/08/12.
//  Copyright (c) 2012 Rounak Jain. All rights reserved.
//

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
    mediump vec4  topLeftColor = texture2D(texture,topLeftTextureCoordinate);
    mediump vec4  topColor = texture2D(texture,topTextureCoordinate);
    mediump vec4  topRightColor = texture2D(texture,topRightTextureCoordinate);
    
    mediump vec4  leftColor = texture2D(texture,leftTextureCoordinate);
    mediump vec4  rightColor = texture2D(texture,rightTextureCoordinate);
    
    mediump vec4  bottomLeftColor = texture2D(texture,bottomLeftTextureCoordinate);
    mediump vec4  bottomColor = texture2D(texture,bottomTextureCoordinate);
    mediump vec4  bottomRightColor = texture2D(texture,bottomRightTextureCoordinate);
    
    
    mediump vec4 xEdge =
    (bottomRightColor - bottomLeftColor)
    + (topRightColor - topLeftColor)
    + (rightColor - leftColor)
    + (rightColor - leftColor);
    mediump vec4 yEdge =
    (bottomLeftColor - topLeftColor)
    + (bottomColor - topColor)
    + (bottomColor - topColor)
    + (bottomRightColor - topRightColor);
    mediump vec3 edge;
    edge.r = sqrt((xEdge.r*xEdge.r)+(yEdge.r*yEdge.r));
    edge.g = sqrt((xEdge.g*xEdge.g)+(yEdge.g*yEdge.g));
    edge.b = sqrt((xEdge.b*xEdge.b)+(yEdge.b*yEdge.b));
    
    
    mediump vec3 netValueAtPixel;
    netValueAtPixel = texture2D(texture,fragmentTextureCoordinate).rgb + sharpen*edge;
    
    gl_FragColor = vec4(netValueAtPixel,1);
}
