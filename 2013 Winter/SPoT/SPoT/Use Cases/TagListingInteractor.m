//
//  TagListingInteractor.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "TagListingInteractor.h"
#import "ImageSupplierGateway.h"

static NSString * const TagListExclusions[] = { @"cs193pspot", @"portrait", @"landscape" };

@interface TagListingInteractor ()

@property (strong, nonatomic) id <ImageSupplierDataSource> photoSupplier;

@end

@implementation TagListingInteractor

#pragma mark - Properties

- (id<ImageSupplierDataSource>)photoSupplier
{
    if (!_photoSupplier) _photoSupplier = [ImageSupplierGateway defaultDataSource];
    return _photoSupplier;
}

#pragma mark - Methods

- (NSArray *)listAllTags
{
    NSArray *tagsToIgnore = [NSArray arrayWithObjects:TagListExclusions count:C_ARRAY_COUNT(TagListExclusions)];
    return [self.photoSupplier listTagsExcluding:tagsToIgnore];
}

@end
