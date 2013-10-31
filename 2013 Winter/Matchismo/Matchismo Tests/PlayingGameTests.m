//
//  PlayingGameTests.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/10/23.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlayingGame.h"
#import "PlayingDeck.h"
#import "PlayingCard.h"

#pragma mark - Test Support

typedef NS_ENUM(NSInteger, PlayingGameFixtureCardIndex) {
    PlayingGameFixtureCardIndexAceHearts,
    PlayingGameFixtureCardIndexAceDiamonds,
    PlayingGameFixtureCardIndexAceSpades,
    PlayingGameFixtureCardIndexThreeSpades,
    PlayingGameFixtureCardIndexFourSpades,
    PlayingGameFixtureCardIndexFiveClubs,
    PLAYING_GAME_FIXTURE_CARDS_INDEX_COUNT
};

@interface PlayingGame (Tests)
@property (nonatomic) NSMutableArray *cards;
@end

#pragma mark - Test Suite

@interface PlayingGameTests : XCTestCase
@property (readonly, nonatomic) PlayingGame *game2;
@property (readonly, nonatomic) PlayingGame *game3;
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
    _game2 = [[PlayingGame alloc] initWithCardCount:[game2Cards count]
                                                fromDeck:discardableDeck
                                              matchCount:2
                                          bonusPenalties:scoresDefinitions];
    _game3 = [[PlayingGame alloc] initWithCardCount:[game3Cards count]
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
    NSMutableArray *cards = [NSMutableArray arrayWithCapacity:PLAYING_GAME_FIXTURE_CARDS_INDEX_COUNT];
    cards[PlayingGameFixtureCardIndexAceHearts] = [self createCardRank:1 withSuit:@"♥"];
    cards[PlayingGameFixtureCardIndexAceDiamonds] = [self createCardRank:1 withSuit:@"♦"];
    cards[PlayingGameFixtureCardIndexAceSpades] = [self createCardRank:1 withSuit:@"♠"];
    cards[PlayingGameFixtureCardIndexThreeSpades] = [self createCardRank:3 withSuit:@"♠"];
    cards[PlayingGameFixtureCardIndexFourSpades] = [self createCardRank:4 withSuit:@"♠"];
    cards[PlayingGameFixtureCardIndexFiveClubs] = [self createCardRank:5 withSuit:@"♣"];
    return cards;
}

- (PlayingCard *)createCardRank:(NSUInteger)rank withSuit:(NSString *)suit
{
    PlayingCard *card = [[PlayingCard alloc] init];
    card.suit = suit;
    card.rank = rank;
    return card;
}

- (void)assertIncreasedScoreOfGame:(PlayingGame *)game
              afterMatchingCardsAt:(NSArray *)cardIndexes
{
    XCTAssertNotNil(game, @"Cannot test if there is no game");
    int initialScore = game.score;
    [self assertCardStateOfGame:game afterMatchingCardsAt:cardIndexes];
    XCTAssert(game.score > initialScore, @"Matching cards should increase the score");
}

- (void)assertCardStateOfGame:(PlayingGame *)game
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

- (void)assertDecreasedScoreOfGame:(PlayingGame *)game
           afterMismatchingCardsAt:(NSArray *)cardIndexes
{
    XCTAssertNotNil(game, @"Cannot test if there is no game");
    int initialScore = game.score;
    [self assertCardStateOfGame:game afterMismatchingCardsAt:cardIndexes];
    XCTAssert(game.score < initialScore, @"Mismatching cards should decrease the score");
}

- (void)assertCardStateOfGame:(PlayingGame *)game
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
    [self assertIncreasedScoreOfGame:self.game2
                afterMatchingCardsAt:@[ @(PlayingGameFixtureCardIndexAceHearts),
                                        @(PlayingGameFixtureCardIndexAceDiamonds) ]];
    
    [self assertIncreasedScoreOfGame:self.game3
                afterMatchingCardsAt:@[ @(PlayingGameFixtureCardIndexAceHearts),
                                        @(PlayingGameFixtureCardIndexAceDiamonds),
                                        @(PlayingGameFixtureCardIndexAceSpades) ]];
}

- (void)testFlippingMatchingSuitsIncreasesTheScore
{
    [self assertIncreasedScoreOfGame:self.game2
                afterMatchingCardsAt:@[ @(PlayingGameFixtureCardIndexThreeSpades),
                                        @(PlayingGameFixtureCardIndexFourSpades) ]];
    
    [self assertIncreasedScoreOfGame:self.game3
                afterMatchingCardsAt:@[ @(PlayingGameFixtureCardIndexAceSpades),
                                        @(PlayingGameFixtureCardIndexThreeSpades),
                                        @(PlayingGameFixtureCardIndexFourSpades) ]];
}

- (void)testFlippingMismatchingCardsGivesPenalties
{
    [self assertDecreasedScoreOfGame:self.game2
             afterMismatchingCardsAt:@[ @(PlayingGameFixtureCardIndexAceHearts),
                                        @(PlayingGameFixtureCardIndexFourSpades) ]];
    
    [self assertDecreasedScoreOfGame:self.game3
             afterMismatchingCardsAt:@[ @(PlayingGameFixtureCardIndexAceHearts),
                                        @(PlayingGameFixtureCardIndexFourSpades),
                                        @(PlayingGameFixtureCardIndexFiveClubs) ]];
}

@end
