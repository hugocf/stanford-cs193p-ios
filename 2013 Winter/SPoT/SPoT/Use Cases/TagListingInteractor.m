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
    return [self.photoSupplier listTagsAvailable];
}

@end
