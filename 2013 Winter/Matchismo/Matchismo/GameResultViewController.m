//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/10.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController()
@property (nonatomic) SEL criteriaForSorting;
@end

@implementation GameResultViewController
{}

#pragma mark - Boilerplate template (for reference)

- (void)setup
{
    // things that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

#pragma mark - Properties

@synthesize criteriaForSorting = _criteriaForSorting;

- (SEL)criteriaForSorting
{
    if (!_criteriaForSorting) _criteriaForSorting = @selector(compareDateDescending:);
    return _criteriaForSorting;
}

- (void)setCriteriaForSorting:(SEL)criteriaForSorting
{
    _criteriaForSorting = criteriaForSorting;
    [self updateUI];
}

#pragma mark - Methods

- (void)updateUI
{
    self.display.text = [[[GameResult allGameResults] sortedArrayUsingSelector:self.criteriaForSorting] componentsJoinedByString:@"\n"];
}

- (IBAction)defineSortingCriteria:(UIButton *)sender
{
    int tag = sender.tag;
    switch (tag) {
        case 2:
            self.criteriaForSorting = @selector(compareScoreDescending:);
            break;
        case 3:
            self.criteriaForSorting = @selector(compareDurationAscending:);
            break;
        default:
            self.criteriaForSorting = @selector(compareDateDescending:);
    }
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

@end
