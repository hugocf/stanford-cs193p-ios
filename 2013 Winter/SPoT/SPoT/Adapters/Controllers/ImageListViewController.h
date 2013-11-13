//
//  ImageListViewController.h
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagEntity.h"

@interface ImageListViewController : UITableViewController

@property (strong, nonatomic) NSArray *imageEntries;
@property (strong, nonatomic) TagEntity *tagForImages;

@end
