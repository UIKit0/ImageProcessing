//
//  Shader.vsh
//  Irritated
//
//  Created by Rounak Jain on 23/08/12.
//  Copyright (c) 2012 Rounak Jain. All rights reserved.
//

attribute vec4 position;
attribute vec2 textureCoordinates;

//uniform highp float texWidth;
uniform sampler2D texture;
uniform float texWidth;
uniform float texHeight;
uniform mediump float sharpen;


varying vec2 fragmentTextureCoordinate;
varying vec2 leftTextureCoordinate;
varying vec2 rightTextureCoordinate;

varying vec2 topTextureCoordinate;
varying vec2 topLeftTextureCoordinate;
varying vec2 topRightTextureCoordinate;

varying vec2 bottomTextureCoordinate;
varying vec2 bottomLeftTextureCoordinate;
varying vec2 bottomRightTextureCoordinate;

void main()
{
    
    gl_Position = position;
    
    vec2 widthStep = vec2(texWidth, 0.0);
    vec2 heightStep = vec2(0.0, texHeight);
    vec2 widthHeightStep = vec2(texWidth, texHeight);
    vec2 widthNegativeHeightStep = vec2(texWidth, -texHeight);
    
    fragmentTextureCoordinate = textureCoordinates.xy;
    leftTextureCoordinate = textureCoordinates.xy - widthStep;
    rightTextureCoordinate = textureCoordinates.xy + widthStep;
    
    topTextureCoordinate = textureCoordinates.xy - heightStep;
    topLeftTextureCoordinate = textureCoordinates.xy - widthHeightStep;
    topRightTextureCoordinate = textureCoordinates.xy + widthNegativeHeightStep;
    
    bottomTextureCoordinate = textureCoordinates.xy + heightStep;
    bottomLeftTextureCoordinate = textureCoordinates.xy - widthNegativeHeightStep;
    bottomRightTextureCoordinate = textureCoordinates.xy + widthHeightStep;
    
}
