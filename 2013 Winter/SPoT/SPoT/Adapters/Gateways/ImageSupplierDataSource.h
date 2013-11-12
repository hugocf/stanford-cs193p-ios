//
//  ImageSupplierDataSource.h
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tag.h"

@protocol ImageSupplierDataSource <NSObject>

/** @return List of `Tag` objects. */
- (NSArray *)listAllTags;

/**
 @param tagsToExclude List of string-evaluated objects defining the ignored tags.
 @return List of `Tag` objects.
 */
- (NSArray *)listTagsExcluding:(NSArray *)tagsToExclude;

/** @return List of `Image` objects. */
- (NSArray *)fetchMax:(NSUInteger)number imagesWithTag:(Tag *)tag;

/** @return List of `Image` objects. */
- (NSArray *)fetchMax:(NSUInteger)number imagesBeforeDate:(NSDate *)date;

@end
