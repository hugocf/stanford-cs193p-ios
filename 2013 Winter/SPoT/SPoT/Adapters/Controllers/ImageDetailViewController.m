//
//  ImageDetailViewController.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "ImageDetailViewController.h"

@interface ImageDetailViewController ()

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
        
        // reset scroll view
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        // load image
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageToDisplay.formats.normal];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        // display into scroll + image view
        if (image) {
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
}

#pragma mark - NSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.scrollView addSubview:self.imageView];
    [self resetImage];
}

@end
