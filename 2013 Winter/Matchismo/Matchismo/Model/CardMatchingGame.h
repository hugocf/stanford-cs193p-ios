//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/08/02.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

/** Designated Initializer */
- (id)initWithCardCount:(NSUInteger)count
               fromDeck:(Deck *)deck
             matchCards:(NSUInteger)numCards;

- (id)initWithCardCount:(NSUInteger)count
               fromDeck:(Deck *)deck;

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSString *lastMessage;
@property (nonatomic) int numCardsToMatch;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@end
