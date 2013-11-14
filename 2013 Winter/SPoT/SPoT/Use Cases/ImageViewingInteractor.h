//
//  PhotoViewingInteractor.h
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagEntity.h"

@interface ImageViewingInteractor : NSObject

- (NSArray *)listImagesByTag:(TagEntity *)tag;
- (NSArray *)listRecentImages;

@end
