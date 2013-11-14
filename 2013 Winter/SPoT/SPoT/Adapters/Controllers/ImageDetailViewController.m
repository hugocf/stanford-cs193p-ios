//
//  ImageDetailViewController.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "ImageDetailViewController.h"

static const CGFloat ImageDetailZoomMin = 0.2f;
static const CGFloat ImageDetailZoomNormal = 1.0f;
static const CGFloat ImageDetailZoomMax = 5.0f;

@interface ImageDetailViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ImageDetailViewController

#pragma mark - Properties

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (void)setImageToDisplay:(ImageEntity *)imageToDisplay
{
    _imageToDisplay = imageToDisplay;
    [self resetImage];
}

#pragma mark - Methods

- (void)resetImage
{
    if (self.scrollView) {
        [self resetDisplayArea];
        [self displayImage:[self loadImage]];
    }
}

- (void)resetDisplayArea
{
    self.scrollView.zoomScale = ImageDetailZoomNormal;
    self.scrollView.contentSize = CGSizeZero;
    self.imageView.image = nil;
}

- (UIImage *)loadImage
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageToDisplay.formats.normal];
    return [[UIImage alloc] initWithData:imageData];
}

- (void)displayImage:(UIImage *)image
{
    if (image) {
        self.scrollView.contentSize = image.size;
        self.imageView.image = image;
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
}

- (void)configureScrollView
{
    self.scrollView.maximumZoomScale = ImageDetailZoomMax;
    self.scrollView.minimumZoomScale = ImageDetailZoomMin;
    self.scrollView.delegate = self;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - UIViewController

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    /* TODO: Add auto scrolling based on UIScrollView’s bounds and the size of the photo. */
    /*       See when in the VC's lifecycle you can do geometry calculations with Autolayout on. */
//    CGFloat zoomFactor;
//    if (self.imageView.image.size.width < self.scrollView.frame.size.width) {
//        zoomFactor = self.scrollView.frame.size.width / self.imageView.image.size.width;
//        self.scrollView.zoomScale = zoomFactor;
//    }
//    [self resetImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.scrollView addSubview:self.imageView];
    [self configureScrollView];
    [self resetImage];
}

@end
