//
//  PhotoViewingInteractor.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "PhotoViewingInteractor.h"
#import "ImageSupplierGateway.h"

@interface PhotoViewingInteractor ()

@property (strong, nonatomic) id <ImageSupplierDataSource> photoSupplier;

@end

@implementation PhotoViewingInteractor

#pragma mark - Properties

- (id<ImageSupplierDataSource>)photoSupplier
{
    if (!_photoSupplier) _photoSupplier = [ImageSupplierGateway defaultDataSource];
    return _photoSupplier;
}

#pragma mark - Methods

- (NSArray *)listByTag:(TagEntity *)tag
{
    return [self.photoSupplier listImagesWithTag:tag];
}

@end
