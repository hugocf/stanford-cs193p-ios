//
//  ImageSupplierGateway.h
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageSupplierDataSource.h"

@interface ImageSupplierGateway : NSObject

+ (id <ImageSupplierDataSource>)defaultDataSource;

@end
