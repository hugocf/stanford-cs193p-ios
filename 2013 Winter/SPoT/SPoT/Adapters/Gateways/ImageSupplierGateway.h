//
//  ImageSupplierGateway.h
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageSupplierDataSource <NSObject>

/** @return List of `NSString` objects. */
- (NSArray *)listTagsAvailable;

/**
 @param tagsToExclude List of string-evaluated objects defining the ignored tags.
 @return List of `NSString` objects.
 */
- (NSArray *)listTagsExcluding:(NSArray *)tagsToExclude;

/** @return List of `Image`[FIXME: wrong!] objects. */
- (NSArray *)fetchMax:(NSUInteger)number imagesWithTag:(NSString *)tag;

/** @return List of `Image`[FIXME: wrong!] objects. */
- (NSArray *)fetchMax:(NSUInteger)number imagesBeforeDate:(NSDate *)date;

@end

@interface ImageSupplierGateway : NSObject

+ (id <ImageSupplierDataSource>)defaultDataSource;

@end
