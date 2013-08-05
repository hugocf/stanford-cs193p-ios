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
@property (readwrite, nonatomic) NSString *lastMessage;
@property (nonatomic) NSMutableArray *cards;

@end

@implementation CardMatchingGame
{}
#pragma mark - Initializers

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

#define SCORE_FLIP_COST         -1
#define SCORE_MISMATCH_PENALTY  -2
#define SCORE_MATCH_BONUS       4

/**
 * The "brain" of the game.
 *
 * This is where the actual game rules are defined.
 * Sets the `lastMessage` property to describe what has been going on in the game.
 */
- (void)flipCardAtIndex:(NSUInteger)index
{
    NSString *msg;
    int roundScore = 0;
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            // play the game
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int cardScore = [card match:@[otherCard]];
                    if (cardScore) {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        roundScore += cardScore * SCORE_MATCH_BONUS;
                        msg = [NSString stringWithFormat:@"Matched %@ & %@\n%d point(s)", card, otherCard, roundScore];
                    } else {
                        otherCard.faceup = NO;
                        roundScore += SCORE_MISMATCH_PENALTY;
                        msg = [NSString stringWithFormat:@"%@ & %@ don't match\n%d point(s)", card, otherCard, roundScore];
                    }
                    break; // nothing more to do here: already found 1 card face up!
                }
            }
            roundScore += SCORE_FLIP_COST;
            if (!msg) {
                msg = [NSString stringWithFormat:@"Flipped up %@", card];
            }
        } else {
            msg = @"";
        }
        // flip it!
        card.faceup = !card.faceup;
        self.score += roundScore;
        self.lastMessage = msg;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count)? self.cards[index] : nil;
}

@end
