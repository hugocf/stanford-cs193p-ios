//
//  ImageSupplierGateway.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "ImageSupplierGateway.h"
#import "ImageSupplierFlickr.h"

@implementation ImageSupplierGateway

+ (id<ImageSupplierDataSource>)defaultDataSource
{
    return [ImageSupplierFlickr sharedImageSupplierFlickr];
}

@end
