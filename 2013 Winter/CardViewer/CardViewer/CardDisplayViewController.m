//
//  CardDisplayViewController.m
//  CardViewer
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardDisplayViewController.h"
#import "PlayingCardView.h"

@interface CardDisplayViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end

@implementation CardDisplayViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.playingCardView.rank = self.rank;
    self.playingCardView.suit = self.suit;
    self.playingCardView.faceUp = YES;
}

@end
