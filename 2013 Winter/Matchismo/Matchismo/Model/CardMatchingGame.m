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

@end

@implementation CardMatchingGame

#pragma mark - Initializers

- (id)initWithCardCount:(NSUInteger)count fromDeck:(Deck *)deck matchCards:(NSUInteger)numCards
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        self.numCardsToMatch = numCards;
    }
    return self;
}

- (id)initWithCardCount:(NSUInteger)count fromDeck:(Deck *)deck
{
    return [self initWithCardCount:count fromDeck:deck matchCards:2];
}

#pragma mark -

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

#define SCORE_FLIP_COST         -1
#define SCORE_MISMATCH_PENALTY  -2
#define SCORE_MATCH_BONUS       4

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
                    playScore += cardScore * SCORE_MATCH_BONUS * (self.numCardsToMatch - 1);
                    playResult = [[PlayResult alloc] initWithCards:[@[card] arrayByAddingObjectsFromArray:cardsInPlay]
                                                     outcome:PlayStatusCardsMatch
                                                       score:playScore];
                } else {
                    // Cards don't match
                    [cardsInPlay enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [obj setFaceup:NO];
                    }];
                    if (cardScore < 0) {
                        playScore += SCORE_MISMATCH_PENALTY * -cardScore;
                    } else {
                        playScore += SCORE_MISMATCH_PENALTY * (self.numCardsToMatch - 1);
                    }
                    playResult = [[PlayResult alloc] initWithCards:[@[card] arrayByAddingObjectsFromArray:cardsInPlay]
                                                           outcome:PlayStatusCardsMismatch
                                                             score:playScore];
                }
            }
            // Score penalty for flipping a card
            playScore += SCORE_FLIP_COST;
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

- (NSMutableArray *)plays
{
    if (!_plays) _plays = [[NSMutableArray alloc] init];
    return _plays;
}

- (NSString *)lastPlay
{
    return [self.plays lastObject];
}

- (NSArray *)lastPlays
{
    return [self.plays copy];
}

@end
