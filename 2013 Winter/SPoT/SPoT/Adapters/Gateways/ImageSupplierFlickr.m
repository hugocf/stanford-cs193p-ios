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

@interface ImageSupplierFlickr ()

@property (strong, nonatomic) NSArray *cachedPhotos;

@end

@implementation ImageSupplierFlickr

#pragma mark - Properties

- (NSArray *)cachedPhotos
{
    if (!_cachedPhotos) _cachedPhotos = [FlickrFetcher stanfordPhotos];
    return _cachedPhotos;
}

#pragma mark - Methods

- (NSUInteger)countImagesWithTag:(NSString *)tagText
{
    return 1;   /* TODO: count from the self.cachedPhotos */
}

#pragma mark - ImageSupplierDataSource

- (NSArray *)listTagsAvailable
{
    // Flickr tag strings
    NSArray *tagsPerPhoto = [self.cachedPhotos valueForKey:FLICKR_TAGS];
    NSArray *allTagsUsed = [[tagsPerPhoto componentsJoinedByString:FlickrTagSeparator]
                            componentsSeparatedByString:FlickrTagSeparator];
    NSSet *uniqueTagList = [NSSet setWithArray:allTagsUsed];
    
    // Wrap in tag entities
    NSMutableArray *tags = [NSMutableArray arrayWithCapacity:[uniqueTagList count]];
    for (NSString *tagText in uniqueTagList) {
        NSUInteger numberOfImages = [self countImagesWithTag:tagText];
        [tags addObject:[[TagEntity alloc] initWithName:tagText imageCount:numberOfImages]];
    }
    
    return [tags copy];
}

- (NSArray *)listTagsExcluding:(NSArray *)tagsToExclude;
{
    return nil;
}

- (NSArray *)fetchMax:(NSUInteger)number imagesWithTag:(TagEntity *)tag;
{
    return nil;
}

- (NSArray *)fetchMax:(NSUInteger)number imagesBeforeDate:(NSDate *)date;
{
    return nil;
}

@end
