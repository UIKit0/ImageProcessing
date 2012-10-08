//
//  ViewController.m
//  SuperIrritated
//
//  Created by Rounak Jain on 23/08/12.
//  Copyright (c) 2012 Rounak Jain. All rights reserved.
//

#import "ViewController.h"
#import "GLProgram.h"
#import "GLCommon.h"



Vertex3D vertices2 [] =
{
    {-0.5f, -0.5f, 0},
    {-0.5f,  0.5f, 0},
    { 0.5f, -0.5f, 0},
    { 0.5f,  0.5f, 0}
};
TextureCoord coordinates [] =
{
    {0,1},
    {0,0},
    {1,1},
    {1,0},
};
@interface ViewController ()
{
    GLKView *_glkView;
    
    
    GLuint _positionAttribute;
    GLuint _textCoordAttribute;
    
    
    GLuint _textureUniform;
    GLuint _texWidthUniform;
    GLuint _texHeightUniform;
    GLuint _sharpenUniform;
    
    
    GLfloat *vertices;
    
    
    GLfloat _texWidth;
    GLfloat _texHeight;
    UISlider *slider;
}
@property GLProgram *program;
@end

@implementation ViewController

- (void)generateVerticesForTexture:(GLKTextureInfo *)passedTexture
{
    if (vertices!=NULL)
    {
        free(vertices);
    }
    GLfloat width = passedTexture.width;
    GLfloat height = passedTexture.height;
    
    GLfloat screenWidth = self.view.frame.size.width;
    GLfloat screenHeight = self.view.frame.size.height;
    
    vertices = (GLfloat*)malloc(3*4*sizeof(GLfloat));
    if (width<=screenWidth && height<=screenHeight)
    {
        const GLfloat vertices1 [] =
        {
            -width/screenWidth,-height/screenHeight,0,
            -width/screenWidth, height/screenHeight,0,
             width/screenWidth,-height/screenHeight,0,
             width/screenWidth, height/screenHeight,0,
        };
        memcpy(vertices, vertices1, sizeof(vertices1));
        _texWidth = 1.0f/width;
        _texHeight = 1.0f/height;
        //NSLog(@"%f",_texWidth);
    }
    else
    {
        GLfloat imageRatio = height/width;
        GLfloat screenRatio = screenHeight/screenWidth;
        
        
        if(imageRatio >= screenRatio)   //compress wrt height
        {
            
        }
        else            //compress wrt width
        {
            
        }
    }
}


- (void)setupGL
{
    vertices = NULL;
    [EAGLContext setCurrentContext:_glkView.context];
    self.program = [[GLProgram alloc] initWithVertexShaderFilename:@"Sobel" fragmentShaderFilename:@"Sobel"];
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"textureCoordinates"];
    
    if (![self.program link])
    {
        NSLog(@"Link failed");
        NSString *progLog = [self.program programLog];
        NSLog(@"Program Log: %@", progLog);
        NSString *fragLog = [self.program fragmentShaderLog];
        NSLog(@"Frag Log: %@", fragLog);
        NSString *vertLog = [self.program vertexShaderLog];
        NSLog(@"Vert Log: %@", vertLog);
        self.program = nil;
    }
    
    
    _positionAttribute = [self.program attributeIndex:@"position"];
    _textCoordAttribute = [self.program attributeIndex:@"textureCoordinates"];
    
    _textureUniform = [self.program uniformIndex:@"texture"];
    //_widthUniform = [self.program uniformIndex:@"texWidth"];
    _texWidthUniform = [self.program uniformIndex:@"texWidth"];
    _texHeightUniform = [self.program uniformIndex:@"texHeight"];
    _sharpenUniform = [self.program uniformIndex:@"sharpen"];
    
    
    GLKTextureInfo *glkTexture = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guy" ofType:@"png"] options:nil error:nil];
    [self generateVerticesForTexture:glkTexture];
    
    /*vertex position*/
    glVertexAttribPointer(_positionAttribute, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionAttribute);
    /*vertex position*/
    
    /*texture coordinate*/
    glVertexAttribPointer(_textCoordAttribute, 2, GL_FLOAT, 0, 0, coordinates);
    glEnableVertexAttribArray(_textCoordAttribute);
    /*texture coordinate*/
    
    
    /*texture*/
    
    glBindTexture(glkTexture.target, glkTexture.name);
    glActiveTexture(GL_TEXTURE0);
    
    /*end texture*/
    
    /*widthUniform*/
    //glUniform1f(_widthUniform, _texWidth);
   // GLfloat temp = 0.5;
   
    [self.program use];
    
    
    
    glUniform1f(_texWidthUniform, _texWidth);
    glUniform1f(_texHeightUniform, _texHeight);
    glUniform1i(_textureUniform, 0);
    glUniform1f(_sharpenUniform, 0.5);
    //Views
    _glkView.enableSetNeedsDisplay = YES;
    _glkView.delegate = self;
}

-(void)sliderChanged:(UISlider*)sender
{
    //sliderValue = sender.value;
    glUniform1f(_sharpenUniform, sender.value);
    [self.view setNeedsDisplay];
   // NSLog(@"Slider called");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"In view did load");
    
    self.view = nil;
    self.view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]];
    _glkView = (GLKView*)self.view;
    [self setupGL];
    
    /* slider setup */
    slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    slider.maximumValue = 1;
    slider.minimumValue = 0;
    slider.value = 0.5;
    
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    

}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //glClearColor(1, 1, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
     
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [EAGLContext setCurrentContext:_glkView.context];
    free(vertices);
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
