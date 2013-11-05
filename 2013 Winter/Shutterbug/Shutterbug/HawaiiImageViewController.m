//
//  HawaiiImageViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "HawaiiImageViewController.h"

@implementation HawaiiImageViewController

// purpose of this entire VC is just to set its Model to a particular photo

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageURL = [[NSURL alloc] initWithString:@"http://images.apple.com/v/iphone/gallery/a/images/photo_3.jpg"];
}

@end
