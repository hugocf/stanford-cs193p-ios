//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/08/02.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (readwrite, nonatomic) int score;
@property (nonatomic) NSMutableArray *cards;

@end

@implementation CardMatchingGame
{}
#pragma mark - Designated Initializer

- (id)initWithCardCount:(NSUInteger)count fromDeck:(Deck *)deck
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
    }
    return self;
}

#pragma mark -

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

#define SCORE_FLIP_COST         1
#define SCORE_MISMATCH_PENALTY  2
#define SCORE_MATCH_BONUS       4

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            // play the game
            self.score -= SCORE_FLIP_COST;
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * SCORE_MATCH_BONUS;
                    } else {
                        otherCard.faceup = NO;
                        self.score -= SCORE_MISMATCH_PENALTY;
                    }
                    break; // nothing more to do here: already found 1 card face up!
                }
            }
        }
        // flip it!
        card.faceup = !card.faceup;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count)? self.cards[index] : nil;
}

@end
