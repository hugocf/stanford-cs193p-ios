//
//  ImageFormatURLs.h
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/13.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFormatURLs : NSObject

@property (readonly, strong, nonatomic) NSURL *thumbnail;
@property (readonly, strong, nonatomic) NSURL *normal;
@property (readonly, strong, nonatomic) NSURL *hires;

///--------------------------------------------------------------------------------
/// @name Initializing an Image
///--------------------------------------------------------------------------------

/** Designated initializer. */
- (id)initWithURL:(NSURL *)normalURL thumbnail:(NSURL *)thumbURL hires:(NSURL *)hiresURL;

+ (id)new  __attribute__((unavailable("use the designated initializer instead")));
- (id)init __attribute__((unavailable("use the designated initializer instead")));

@end
