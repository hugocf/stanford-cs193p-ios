//
//  PhotoViewingInteractor.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "ImageViewingInteractor.h"
#import "ImageSupplierGateway.h"

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

@end
