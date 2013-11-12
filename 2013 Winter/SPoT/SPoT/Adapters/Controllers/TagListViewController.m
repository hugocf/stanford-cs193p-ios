//
//  TagListViewController.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "TagListViewController.h"
#import "TagListing.h"

static NSString * const TagListCellReuseIdentifier = @"TagName";
static NSString * const TagListCellSegueIdentifier = @"ShowImagesForTag";

@interface TagListViewController ()

@end

@implementation TagListViewController

#pragma mark - Properties

- (void)setTagEntries:(NSArray *)tagEntries
{
    _tagEntries = tagEntries;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tagEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TagListCellReuseIdentifier
                                                            forIndexPath:indexPath];
//    cell.textLabel.text = ((__TBD__ *)self.tags[indexPath.row]).title;
//    cell.detailTextLabel.text = ((__TBD__ *)self.tags[indexPath.row]).subtitle;
    cell.textLabel.text = self.tagEntries[indexPath.row];
    cell.detailTextLabel.text = self.tagEntries[indexPath.row];
    return cell;
}

#pragma mark - UIViewController

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tagEntries = [[TagListing new] listAllTags];
}

@end
