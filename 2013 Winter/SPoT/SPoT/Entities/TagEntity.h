//
//  TagEntity.h
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagEntity : NSObject

@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, nonatomic) NSUInteger numberOfImages;

///--------------------------------------------------------------------------------
/// @name Initializing a Tag
///--------------------------------------------------------------------------------

/** Designated initializer. */
- (id)initWithName:(NSString *)name imageCount:(NSUInteger)count;

@end
