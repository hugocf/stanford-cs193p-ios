//
//  ImageSupplierFlickr.h
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageSupplierGateway.h"

@interface ImageSupplierFlickr : NSObject <ImageSupplierDataSource>

+ (instancetype)sharedImageSupplierFlickr;

@end
