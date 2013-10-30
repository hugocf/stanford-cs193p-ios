//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/08/02.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayResult.h"

@interface CardMatchingGame()

@property (readwrite, nonatomic) int score;
@property (nonatomic) NSMutableArray *plays;
@property (nonatomic) NSMutableArray *cards;
@property (nonatomic, readonly) ScoreDefinitions weights;

@end

@implementation CardMatchingGame

#pragma mark - Initializers

- (id)initWithCardCount:(NSUInteger)count
               fromDeck:(Deck *)deck
             matchCount:(NSUInteger)numCards
         bonusPenalties:(ScoreDefinitions)scoreSettings
{
    self = [super init];
    if (self) {
        for (NSUInteger i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
                return self;
            }
            self.cards[i] = card;
        }
        self.numCardsToMatch = numCards;
        _weights = scoreSettings;
    }
    return self;
}

- (id)initWithCardCount:(NSUInteger)count fromDeck:(Deck *)deck
{
    return [self initWithCardCount:count
                          fromDeck:deck
                        matchCount:2
                    bonusPenalties:(ScoreDefinitions){-1, -1, 2}];
}

#pragma mark - Properties

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)plays
{
    if (!_plays) _plays = [[NSMutableArray alloc] init];
    return _plays;
}

#pragma mark - Methods

/**
 The "brain" of the game.
 
 This is where the actual game rules are defined.
 Stores que result of each play to describe what has been going on in the game.
 */
- (void)flipCardAtIndex:(NSUInteger)index
{
    PlayResult *playResult;
    int playScore = 0;
    Card *card = [self cardAtIndex:index];
    
    BOOL(^isCardInPlay)(id, NSUInteger, BOOL*) = ^(id obj, NSUInteger idx, BOOL *stop) {
        return (BOOL)(![(Card *)obj isUnplayable] && [(Card *)obj isFaceUp]);
    };
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            // Play the game
            NSArray *cardsInPlay = [self.cards objectsAtIndexes:[self.cards indexesOfObjectsPassingTest:isCardInPlay]];
            
            // Check for a match if enough cards are flipped
            if (cardsInPlay.count == self.numCardsToMatch - 1) {
                int cardScore = [card match:cardsInPlay];
                if (cardScore > 0) {
                    // Cards match
                    card.unplayable = YES;
                    [cardsInPlay enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [obj setUnplayable:YES];
                    }];
                    playScore += cardScore * self.weights.matchBonus * ((int)self.numCardsToMatch - 1);
                    playResult = [[PlayResult alloc] initWithCards:[@[card] arrayByAddingObjectsFromArray:cardsInPlay]
                                                     outcome:PlayStatusCardsMatch
                                                       score:playScore];
                } else {
                    // Cards don't match
                    [cardsInPlay enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [obj setFaceup:NO];
                    }];
                    if (cardScore < 0) {
                        playScore += self.weights.mismatchPenalty * -cardScore;
                    } else {
                        playScore += self.weights.mismatchPenalty * ((int)self.numCardsToMatch - 1);
                    }
                    playResult = [[PlayResult alloc] initWithCards:[@[card] arrayByAddingObjectsFromArray:cardsInPlay]
                                                           outcome:PlayStatusCardsMismatch
                                                             score:playScore];
                }
            }
            // Score penalty for flipping a card
            playScore += self.weights.flipCost;
            if (!playResult) {
                playResult = [[PlayResult alloc] initWithCards:@[card]
                                                       outcome:PlayStatusCardFlipped
                                                         score:playScore];
            }
        }
        // Flip it!
        card.faceup = !card.faceup;
        self.score += playScore;
        if (playResult) {
            [self.plays addObject:playResult];
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count)? self.cards[index] : nil;
}

- (NSString *)lastPlay
{
    return [self.plays lastObject];
}

- (NSArray *)lastPlays
{
    return [self.plays copy];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"Card[%d]", self.numCardsToMatch];
}

@end
