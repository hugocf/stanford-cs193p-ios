//
//  TagListViewController.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/07.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "TagListViewController.h"
#import "TagListingInteractor.h"
#import "TagEntity.h"

static NSString * const TagListCellReuseIdentifier = @"TagName";
static NSString * const TagListCellSegueIdentifier = @"ShowImagesForTag";
static NSString * const TagListSubtitleText = @"%d photo%@";

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
    TagEntity *tag = (TagEntity *)self.tagEntries[indexPath.row];
    BOOL isPlural = tag.numberOfImages > 1;
    cell.textLabel.text = tag.description;
    cell.detailTextLabel.text = [NSString stringWithFormat:TagListSubtitleText, tag.numberOfImages, (isPlural)? @"s" : @""];
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
    self.tagEntries = [[TagListingInteractor new] listAllTags];
}

@end
