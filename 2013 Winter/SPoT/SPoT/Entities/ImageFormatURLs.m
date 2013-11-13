//
//  ImageFormatURLs.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/13.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "ImageFormatURLs.h"

@implementation ImageFormatURLs

#pragma mark - Initialization

- (id)initWithURL:(NSURL *)normalURL thumbnail:(NSURL *)thumbURL hires:(NSURL *)hiresURL
{
    self = [super init];
    if (self) {
        _normal = normalURL;
        _thumbnail = thumbURL;
        _hires = hiresURL;
    }
    return self;
}

@end
