//
//  SuperCardViewController.m
//  SuperCard
//
//  Created by Hugo Ferreira on 2013/09/26.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "SuperCardViewController.h"
#import "PlayingCardView.h"

@interface SuperCardViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCard;
@end

@implementation SuperCardViewController

#pragma mark - Properties

- (void)setPlayingCard:(PlayingCardView *)playingCard
{
    _playingCard = playingCard;
    playingCard.rank = 13; // K
    playingCard.suit = @"♥";
}

#pragma mark - Methods

- (IBAction)swipeCard:(UISwipeGestureRecognizer *)sender
{
    self.playingCard.faceUp = !self.playingCard.isFaceUp;
}

@end
