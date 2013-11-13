//
//  TagEntity.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "TagEntity.h"

@implementation TagEntity

#pragma mark - Initialization

- (id)initWithName:(NSString *)name imageCount:(NSUInteger)count
{
    self = [super init];
    if (self) {
        _name = name;
        _numberOfImages = count;
    }
    return self;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [self.name capitalizedString];
}

@end
