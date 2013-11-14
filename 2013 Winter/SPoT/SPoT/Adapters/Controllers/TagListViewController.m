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
#import "ImageViewingInteractor.h"

static NSString * const TagListCellReuseIdentifier = @"TagName";
static NSString * const TagListCellSegueIdentifier = @"ShowImagesForTag";
static NSString * const TagListCellSegueSelector = @"setTagForImages:";
static NSString * const TagListSubtitleText = @"%ld photo%@";

@interface TagListViewController ()

@end

@implementation TagListViewController

#pragma mark - Properties

- (void)setTagEntries:(NSArray *)tagEntries
{
    _tagEntries = tagEntries;
    [self.tableView reloadData];
}

#pragma mark - Methods

- (NSArray *)sortAlphabetically:(NSArray *)tagList
{
    NSSortDescriptor *byAscendingName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    return [tagList sortedArrayUsingDescriptors:@[byAscendingName]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.tagEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TagListCellReuseIdentifier
                                                            forIndexPath:indexPath];
    TagEntity *tag = (TagEntity *)self.tagEntries[(NSUInteger)indexPath.row];
    BOOL isPlural = tag.numberOfImages > 1;
    cell.textLabel.text = tag.description;
    cell.detailTextLabel.text = [NSString stringWithFormat:TagListSubtitleText,
                                 (unsigned long)tag.numberOfImages, (isPlural)? @"s" : @""];
    return cell;
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:TagListCellSegueIdentifier]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            if (indexPath) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                if ([segue.destinationViewController respondsToSelector:@selector(setImageEntries:)]) {
                    TagEntity *tag = self.tagEntries[(NSUInteger)indexPath.row];
                    NSArray * images = [[ImageViewingInteractor new] listImagesByTag:tag];
                    [segue.destinationViewController performSelector:@selector(setImageEntries:) withObject:images];
                }
#pragma clang diagnostic pop
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.tagEntries) {
        NSArray *tagList = [[TagListingInteractor new] listAllTags];
        self.tagEntries = [self sortAlphabetically:tagList];
    }
}

@end
