//
//  ImageEntity.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "ImageEntity.h"

@implementation ImageEntity

- (id)initWithTitle:(NSString *)titleText
        description:(NSString *)descriptionText
             author:(NSString *)authorName
            formats:(ImageFormatURLs *)formatURLs
{
    self = [super init];
    if (self) {
        _title = titleText;
        _description = descriptionText;
        _author = authorName;
        _formats = formatURLs;
    }
    return self;
}

@end
