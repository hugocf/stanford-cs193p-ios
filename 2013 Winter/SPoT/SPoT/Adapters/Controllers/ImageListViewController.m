//
//  ImageListViewController.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "ImageListViewController.h"
#import "ImageDetailViewController.h"
#import "ImageViewingInteractor.h"
#import "ImageEntity.h"

static NSString * const ImageListCellReuseIdentifier = @"ImageName";

@interface ImageListViewController ()

@end

@implementation ImageListViewController

#pragma mark - Properties

- (void)setImageEntries:(NSArray *)imageEntries
{
    _imageEntries = imageEntries;
    [self.tableView reloadData];
}

- (void)setTagForImages:(TagEntity *)tagForImages
{
    _tagForImages = tagForImages;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.imageEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageListCellReuseIdentifier
                                                            forIndexPath:indexPath];
    ImageEntity *image = (ImageEntity *)self.imageEntries[(NSUInteger)indexPath.row];
    cell.textLabel.text = image.title;
    cell.detailTextLabel.text = image.description;
    return cell;
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.destinationViewController isKindOfClass:[ImageDetailViewController class]]) {
                ImageEntity *image = self.imageEntries[(NSUInteger)indexPath.row];
                ((ImageDetailViewController *)segue.destinationViewController).imageToDisplay = image;
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageEntries = [[ImageViewingInteractor new] listImagesByTag:self.tagForImages];
}

@end
