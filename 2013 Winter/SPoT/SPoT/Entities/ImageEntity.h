//
//  ImageEntity.h
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageFormatURLs.h"

@interface ImageEntity : NSObject

@property (readonly, strong, nonatomic) NSString *title;
@property (readonly, strong, nonatomic) NSString *description;
@property (readonly, strong, nonatomic) NSString *author;
@property (readonly, strong, nonatomic) ImageFormatURLs *formats;

///--------------------------------------------------------------------------------
/// @name Initializing an Image
///--------------------------------------------------------------------------------

/** Designated initializer. */
- (id)initWithTitle:(NSString *)titleText
        description:(NSString *)descriptionText
             author:(NSString *)authorName
            formats:(ImageFormatURLs *)formatURLs;

+ (id)new  __attribute__((unavailable("use the designated initializer instead")));
- (id)init __attribute__((unavailable("use the designated initializer instead")));

@end
