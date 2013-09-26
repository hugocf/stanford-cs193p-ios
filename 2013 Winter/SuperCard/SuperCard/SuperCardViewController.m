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

#pragma mark - <#Class#><#Initialization#><#Properties#><#Methods#><#NSClassName#>

- (void)setPlayingCard:(PlayingCardView *)playingCard
{
    _playingCard = playingCard;
    playingCard.rank = 13; // K
    playingCard.suit = @"♥";
}

@end
