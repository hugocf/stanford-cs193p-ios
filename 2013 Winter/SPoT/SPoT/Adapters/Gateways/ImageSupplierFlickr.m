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

- (NSSet *)uniqueTagStrings
{
    NSArray *tagsPerPhoto = [self.cachedPhotos valueForKey:FLICKR_TAGS];
    NSArray *allTagsUsed = [[tagsPerPhoto componentsJoinedByString:FlickrTagSeparator]
                            componentsSeparatedByString:FlickrTagSeparator];
    NSSet *uniqueTagList = [NSSet setWithArray:allTagsUsed];
    return uniqueTagList;
}

- (NSArray *)wrapInTagEntries:(NSSet *)tagList
{
    NSMutableArray *tags = [NSMutableArray arrayWithCapacity:[tagList count]];
    for (NSString *tagText in tagList) {
        NSUInteger numberOfImages = [self countImagesWithTag:tagText];
        [tags addObject:[[TagEntity alloc] initWithName:tagText imageCount:numberOfImages]];
    }
    return [tags copy];
}

- (NSUInteger)countImagesWithTag:(NSString *)tagText
{
    BOOL(^imageContainsTag)(id, NSUInteger, BOOL*) = ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSRange search = [obj[FLICKR_TAGS] rangeOfString:tagText];
        return search.location != NSNotFound;
    };
    NSIndexSet *matchingImageIndexes = [self.cachedPhotos indexesOfObjectsPassingTest:imageContainsTag];
    return [matchingImageIndexes count];
}

#pragma mark - ImageSupplierDataSource

- (NSArray *)listTagsAvailable
{
    NSSet *uniqueTagList = [self uniqueTagStrings];
    return [self wrapInTagEntries:uniqueTagList];
}

- (NSArray *)listTagsExcluding:(NSArray *)tagsToExclude;
{
    NSMutableSet *uniqueTagList = [[self uniqueTagStrings] mutableCopy];
    for (NSString *excludeTag in tagsToExclude) {
        [uniqueTagList removeObject:excludeTag];
    }
    return [self wrapInTagEntries:uniqueTagList];
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
