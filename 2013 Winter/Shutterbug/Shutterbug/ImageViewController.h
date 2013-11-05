//
//  ImageViewController.h
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

// the Model for this VC
// simply the URL of a UIImage-compatible image (jpg, png, etc.)
@property (nonatomic, strong) NSURL *imageURL;

@end
