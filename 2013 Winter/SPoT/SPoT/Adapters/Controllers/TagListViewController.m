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
static NSString * const TagListCellSegueSelector = @"setTagForImages:";
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:TagListCellSegueIdentifier]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            if (indexPath) {
                if ([segue.destinationViewController respondsToSelector:@selector(setTagForImages:)]) {
                    TagEntity *tag = self.tagEntries[indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setTagForImages:) withObject:tag];
                }
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *tagList = [[TagListingInteractor new] listAllTags];
    NSSortDescriptor *byAscendingName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.tagEntries = [tagList sortedArrayUsingDescriptors:@[byAscendingName]];
}

@end
