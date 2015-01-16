//
//  ViewController.m
//  CADisplayLink
//
//  Created by GabrielMassana on 14/01/2015.
//  Copyright (c) 2015 GabrielMassana. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerTwo.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) UIImageView *animationImageView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSInteger frameNumber;

@end

@implementation ViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.animationImageView];
    [self.view addSubview:self.button];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self animateImages];
}

#pragma mark - Subviews

- (UIImageView *)animationImageView
{
    if (!_animationImageView)
    {
        _animationImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return _animationImageView;
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0,
                                   20,
                                   [[UIScreen mainScreen] bounds].size.width,
                                   80);
        _button.backgroundColor = [UIColor redColor];
        
        [_button addTarget:self
                    action:@selector(buttonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _button;
}

#pragma mark - Getters

- (NSArray *)imagesArray
{
    if (!_imagesArray)
    {
        _imagesArray = [self createImagesArray];
    }
    
    return _imagesArray;
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink)
    {
        _displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(linkProgress)];
    }
    
    return _displayLink;
}

#pragma mark - ButtonActions

-(void)buttonPressed
{
    ViewControllerTwo *two = [[ViewControllerTwo alloc] init];
    
    [self presentViewController:two animated:YES completion:nil];
}

#pragma mark - CreateImagesArray

- (NSArray *)createImagesArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index <= 16; index++)
    {
        NSString *imageName = [NSString stringWithFormat:@"frame_%03ld.png", (long)index];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName
                                                         ofType:nil];
        
        // Allocating images with imageWithContentsOfFile makes images to do not cache.
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [array addObject:image];
    }
    
    return array;
}

#pragma mark - Animation

- (void)animateImages
{
    self.displayLink.frameInterval = 5;
    self.frameNumber = 0;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSRunLoopCommonModes];
}

- (void)linkProgress
{
    if (self.frameNumber > 16)
    {
        [self.displayLink invalidate];
        self.displayLink = nil;
        self.animationImageView.image = [UIImage imageNamed:@"frame_016"];
        self.imagesArray = nil;
        return;
    }

    self.animationImageView.image = self.imagesArray[self.frameNumber++];
    self.frameNumber++;
}

#pragma mark - MemoryManagement

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
