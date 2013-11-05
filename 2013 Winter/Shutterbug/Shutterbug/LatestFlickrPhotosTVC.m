//
//  LatestFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "LatestFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@implementation LatestFlickrPhotosTVC

// purpose of this entire VC is just to set its Model by querying Flickr using FlickrFetcher

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [FlickrFetcher latestGeoreferencedPhotos];
}


@end
