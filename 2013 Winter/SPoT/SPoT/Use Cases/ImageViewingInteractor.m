//
//  PhotoViewingInteractor.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "ImageViewingInteractor.h"
#import "ImageSupplierGateway.h"    /* FIXME: Isn't this breaking the Dependency Rule? */

@interface ImageViewingInteractor ()

@property (strong, nonatomic) id <ImageSupplierDataSource> photoSupplier;

@end

@implementation ImageViewingInteractor

#pragma mark - Properties

- (id<ImageSupplierDataSource>)photoSupplier
{
    if (!_photoSupplier) _photoSupplier = [ImageSupplierGateway defaultDataSource];
    return _photoSupplier;
}

#pragma mark - Methods

- (NSArray *)listImagesByTag:(TagEntity *)tag
{
    return [self.photoSupplier listImagesWithTag:tag];
}

- (NSArray *)listRecentImages
{
    /* TODO: Load from [NSUserDefaults standardUserDefaults] if exists, fetch online otherwise */
    NSArray *photos = [self.photoSupplier listImagesRecentlyUploaded];
    photos = [self removeDuplicates:photos];
    photos = [self sortByMostRecent:photos];
    return photos;
}

- (NSArray *)removeDuplicates:(NSArray *)photos
{
    /* TODO: implement this someday (based on FLICKR_PHOTO_ID) */
    return photos;
}

- (NSArray *)sortByMostRecent:(NSArray *)photos
{
    /* TODO: implement this someday */
    return photos;
}

@end
