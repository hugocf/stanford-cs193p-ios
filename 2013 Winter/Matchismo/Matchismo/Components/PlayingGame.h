//
//  PlayingGame.h
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/08/02.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"
@class PlayResult;

typedef struct {
    NSInteger flipCost;
    NSInteger mismatchPenalty;
    NSInteger matchBonus;
} ScoreDefinitions;

@interface PlayingGame : NSObject

/** Designated Initializer */
- (id)initWithCardCount:(NSUInteger)count
               fromDeck:(Deck *)deck
             matchCount:(NSUInteger)numCards
         bonusPenalties:(ScoreDefinitions)scoreSettings;

- (id)initWithCardCount:(NSUInteger)count
               fromDeck:(Deck *)deck;

@property (readonly, nonatomic) int score;
@property (nonatomic) NSUInteger numCardsToMatch;

- (PlayResult *)lastPlay;

- (NSArray *)lastPlays;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@end
