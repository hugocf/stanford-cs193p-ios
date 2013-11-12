//
//  ImageSupplierFlickr.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "ImageSupplierFlickr.h"
#import "FlickrFetcher.h"

static NSString * const FlickrTagSeparator = @" ";

@implementation ImageSupplierFlickr

#pragma mark - ImageSupplierDataSource

- (NSArray *)listAllTags
{
    NSArray *photos = [FlickrFetcher stanfordPhotos];
    NSArray *tagsPerPhoto = [photos valueForKey:FLICKR_TAGS];
    NSArray *allTagsUsed = [[tagsPerPhoto componentsJoinedByString:FlickrTagSeparator]
                            componentsSeparatedByString:FlickrTagSeparator];
    NSSet *uniqueTagList = [NSSet setWithArray:allTagsUsed];
    return [uniqueTagList allObjects];
}

- (NSArray *)listTagsExcluding:(NSArray *)tagsToExclude;
{
    return nil;
}

- (NSArray *)fetchMax:(NSUInteger)number imagesWithTag:(Tag *)tag;
{
    return nil;
}

- (NSArray *)fetchMax:(NSUInteger)number imagesBeforeDate:(NSDate *)date;
{
    return nil;
}

@end
