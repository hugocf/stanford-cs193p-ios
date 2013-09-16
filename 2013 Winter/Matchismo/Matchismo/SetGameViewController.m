//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetMatchingGame.h"
#import "SetDeck.h"

@interface CardGameViewController ()
@property (strong, nonatomic) NSArray *cardButtons;
@end

@implementation SetGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[SetMatchingGame alloc] initWithCardCount:super.cardButtons.count
                                                           fromDeck:[[SetDeck alloc] init]
                                                         matchCards:3];
    return _game;
}

@end
