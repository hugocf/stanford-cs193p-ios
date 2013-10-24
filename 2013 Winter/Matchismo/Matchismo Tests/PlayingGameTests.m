//
//  PlayingGameTests.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/10/23.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CardMatchingGame.h"
#import "PlayingDeck.h"
#import "PlayingCard.h"

#pragma mark - Test Support

@interface CardMatchingGame (Tests)
@property (nonatomic) NSMutableArray *cards;
@end

#pragma mark - Test Suite

@interface PlayingGameTests : XCTestCase
@property (readonly, nonatomic) CardMatchingGame *game2;
@property (readonly, nonatomic) CardMatchingGame *game3;
@end

@implementation PlayingGameTests

#pragma mark - Each Method

- (void)setUp
{
    [super setUp];
    
    // Define fixtures parameters
    NSArray *game2Cards = [self createFixtureCards];
    NSArray *game3Cards = [self createFixtureCards];
    PlayingDeck *discardableDeck = [[PlayingDeck alloc] init];
    ScoreDefinitions scoresDefinitions = (ScoreDefinitions){-1, -2, 4};
    
    // Instancitate the game fixtures
    _game2 = [[CardMatchingGame alloc] initWithCardCount:[game2Cards count]
                                                fromDeck:discardableDeck
                                              matchCount:2
                                          bonusPenalties:scoresDefinitions];
    _game3 = [[CardMatchingGame alloc] initWithCardCount:[game3Cards count]
                                                fromDeck:discardableDeck
                                              matchCount:3
                                          bonusPenalties:scoresDefinitions];
    // Inject fixture cards into the games
    self.game2.cards = [game2Cards mutableCopy];
    self.game3.cards = [game3Cards mutableCopy];
}

#pragma mark - Helpers

- (NSArray *)createFixtureCards
{
    return @[
             [self createCardRank:1 withSuit:@"♥"],
             [self createCardRank:1 withSuit:@"♦"],
             [self createCardRank:1 withSuit:@"♠"],
             [self createCardRank:3 withSuit:@"♠"],
             [self createCardRank:4 withSuit:@"♠"],
             [self createCardRank:5 withSuit:@"♣"],
             ];
}

- (PlayingCard *)createCardRank:(NSUInteger)rank withSuit:(NSString *)suit
{
    PlayingCard *card = [[PlayingCard alloc] init];
    card.suit = suit;
    card.rank = rank;
    return card;
}

- (void)assertIncreasedScoreOfGame:(CardMatchingGame *)game
              afterMatchingCardsAt:(NSArray *)cardIndexes
{
    XCTAssertNotNil(game, @"Cannot test if there is no game");
    int initialScore = game.score;
    [self assertCardStateOfGame:game afterMatchingCardsAt:cardIndexes];
    XCTAssert(game.score > initialScore, @"Matching cards should increase the score");
}

- (void)assertCardStateOfGame:(CardMatchingGame *)game
         afterMatchingCardsAt:(NSArray *)cardIndexes
{
    // Flip the cards
    for (NSNumber *index in cardIndexes) {
        [game flipCardAtIndex:[index unsignedIntegerValue]];
    }
    // Assert their state
    for (NSNumber *index in cardIndexes) {
        NSUInteger cardIndex = [index unsignedIntegerValue];
        XCTAssertTrue([game cardAtIndex:cardIndex].isFaceUp, @"Flipped card should be facing up");
        XCTAssertTrue([game cardAtIndex:cardIndex].isUnplayable, @"Matched cards cannot be played again");
    }
}

- (void)assertDecreasedScoreOfGame:(CardMatchingGame *)game
           afterMismatchingCardsAt:(NSArray *)cardIndexes
{
    XCTAssertNotNil(game, @"Cannot test if there is no game");
    int initialScore = game.score;
    [self assertCardStateOfGame:game afterMismatchingCardsAt:cardIndexes];
    XCTAssert(game.score < initialScore, @"Mismatching cards should decrease the score");
}

- (void)assertCardStateOfGame:(CardMatchingGame *)game
      afterMismatchingCardsAt:(NSArray *)cardIndexes
{
    // Flip the cards
    for (NSNumber *index in cardIndexes) {
        [game flipCardAtIndex:[index unsignedIntegerValue]];
    }
    // Assert their state
    for (NSUInteger i; i < [cardIndexes count]; i++) {
        NSUInteger cardIndex = [cardIndexes[i] unsignedIntegerValue];
        BOOL isLastItem = (i == [cardIndexes count] - 1);
        if (isLastItem) {
            XCTAssertTrue([game cardAtIndex:cardIndex].isFaceUp, @"Last flipped card should be facing up");
        } else {
            XCTAssertFalse([game cardAtIndex:cardIndex].isFaceUp, @"First flipped cards should be facing down");
        }
        XCTAssertFalse([game cardAtIndex:cardIndex].isUnplayable, @"Mismatched cards should be playable again");
    }
}

#pragma mark - Test Cases

- (void)testFlippingMatchingRanksIncreasesTheScore
{
    [self assertIncreasedScoreOfGame:self.game2 afterMatchingCardsAt:@[ @0, @1 ]];
    [self assertIncreasedScoreOfGame:self.game3 afterMatchingCardsAt:@[ @0, @1, @2 ]];
}

- (void)testFlippingMatchingSuitsIncreasesTheScore
{
    [self assertIncreasedScoreOfGame:self.game2 afterMatchingCardsAt:@[ @3, @4 ]];
    [self assertIncreasedScoreOfGame:self.game3 afterMatchingCardsAt:@[ @2, @3, @4 ]];
}

- (void)testFlippingMismatchingCardsGivesPenalties
{
    [self assertDecreasedScoreOfGame:self.game2 afterMismatchingCardsAt:@[ @0, @4 ]];
    [self assertDecreasedScoreOfGame:self.game3 afterMismatchingCardsAt:@[ @0, @4, @5 ]];
}

@end