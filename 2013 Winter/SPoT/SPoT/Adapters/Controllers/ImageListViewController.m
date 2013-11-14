//
//  ImageListViewController.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "ImageListViewController.h"
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageEntries = [[ImageViewingInteractor new] listImagesByTag:self.tagForImages];
}

@end
