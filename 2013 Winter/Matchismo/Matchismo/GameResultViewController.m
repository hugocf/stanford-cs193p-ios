//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/10.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

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

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - Methods

- (void)updateUI
{
    self.display.text = [[GameResult allGameResults] componentsJoinedByString:@"\n"];
}

@end
