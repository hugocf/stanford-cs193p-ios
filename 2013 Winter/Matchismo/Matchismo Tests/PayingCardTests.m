//
//  PlayingCardTests.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/10/16.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlayingCard.h"

@interface PayingCardTests : XCTestCase
@property (readonly, nonatomic) PlayingCard *defaultCard;
@property (readonly, nonatomic) PlayingCard *aceDiamonds;
@end

@implementation PayingCardTests

#pragma mark - Each Method

- (void)setUp
{
    [super setUp];
    _defaultCard = [[PlayingCard alloc] init];
    _aceDiamonds = [self createCardRank:1 withSuit:@"♦"];
}

#pragma mark - Helpers

- (PlayingCard *)createCardRank:(NSUInteger)rank withSuit:(NSString *)suit
{
    PlayingCard *card = [[PlayingCard alloc] init];
    card.suit = suit;
    card.rank = rank;
    return card;
}

- (NSArray *)createAllCardsOfSuit:(NSString *)suit
{
    NSMutableArray *allCards = [[NSMutableArray alloc] init];
    for (NSUInteger rank = 1; rank < [PlayingCard maxRank]; rank++) {
        [allCards addObject:[self createCardRank:rank withSuit:suit]];
    }
    return [allCards copy];
}

- (NSArray *)createAllCardsOfRank:(NSUInteger)rank
{
    NSMutableArray *allCards = [[NSMutableArray alloc] init];
    for (NSString *suit in [PlayingCard validSuits]) {
        [allCards addObject:[self createCardRank:rank withSuit:suit]];
    }
    return [allCards copy];
}

- (NSArray *)createAllCards
{
    NSMutableArray *allCards = [[NSMutableArray alloc] init];
    for (NSString *suit in [PlayingCard validSuits]) {
        [allCards addObjectsFromArray:[self createAllCardsOfSuit:suit]];
    }
    return [allCards copy];
}

- (void)assertEachCardIn:(NSArray *)matchCards matches:(NSArray *)againstCards
{
    for (PlayingCard *oneCard in matchCards) {
        for (PlayingCard *anotherCard in againstCards) {
            XCTAssert([oneCard match:@[anotherCard]], @"Cards %@ and %@ did not match", oneCard, anotherCard);
        }
    }
}

#pragma mark - Test Cases

- (void)testCardsCanBeTurnedAround
{
    XCTAssertFalse(self.aceDiamonds.isFaceUp, @"Cards should start face down");
    self.aceDiamonds.faceup = YES;
    XCTAssertTrue(self.aceDiamonds.isFaceUp, @"Cards must be able to turn face up");
}

- (void)testCardsCanBeDisabled
{
    XCTAssertFalse(self.aceDiamonds.isUnplayable, @"Cards should start being playable");
    self.aceDiamonds.unplayable = YES;
    XCTAssertTrue(self.aceDiamonds.isUnplayable, @"Cards must be able to be disabled for the game");
}

- (void)testCardsMatchThemselves
{
    NSArray *matchCards = [self createAllCards];
    NSArray *againstCards = [self createAllCards];
    for (NSUInteger i = 0; i < [matchCards count]; i++) {
        PlayingCard *oneCard = matchCards[i];
        PlayingCard *anotherCard = againstCards[i];
        XCTAssert([oneCard match:@[oneCard]], @"Card %@ is not equal to itself?", oneCard);
        XCTAssert([oneCard match:@[anotherCard]], @"Cards %@ and %@ did not match", oneCard, anotherCard);
    }
}

- (void)testCardsOfTheSameSuitMatch
{
    for (NSString *suit in [PlayingCard validSuits]) {
        NSArray *suitCards = [self createAllCardsOfSuit:suit];
        [self assertEachCardIn:suitCards matches:suitCards];
    }
}

- (void)testCardsOfTheSameRankMatch
{
    for (NSUInteger rank = 1; rank < [PlayingCard maxRank]; rank++) {
        NSArray *rankCards = [self createAllCardsOfRank:rank];
        [self assertEachCardIn:rankCards matches:rankCards];
    }
}

- (void)testCardsWithDifferentSuitsAndRanksDontMatch
{
    NSArray *allCards = [self createAllCards];
    for (PlayingCard *oneCard in allCards) {
        for (PlayingCard *anotherCard in allCards) {
            BOOL sameRank = oneCard.rank == anotherCard.rank;
            BOOL sameSuit = [oneCard.suit isEqualToString:anotherCard.suit];
            if (!sameRank && !sameSuit) {
                XCTAssertFalse([oneCard match:@[anotherCard]], @"Cards %@ and %@ did should not match", oneCard, anotherCard);
            }
        }
    }
}

- (void)testCannotCreateCardsWithInvalidRank
{
    for (NSString *suit in [PlayingCard validSuits]) {
        PlayingCard *negativeCard = [self createCardRank:(NSUInteger)-1 withSuit:suit];
        PlayingCard *zeroRankCard = [self createCardRank:0 withSuit:suit];
        PlayingCard *hugeRankCard = [self createCardRank:[PlayingCard maxRank]+1 withSuit:suit];
        XCTAssertEqual(negativeCard.rank, self.defaultCard.rank);
        XCTAssertEqual(zeroRankCard.rank, self.defaultCard.rank);
        XCTAssertEqual(hugeRankCard.rank, self.defaultCard.rank);
    }
}

- (void)testCannotCreateCardsWithInvalidSuit
{
    for (NSUInteger rank = 1; rank < [PlayingCard maxRank]; rank++) {
        PlayingCard *nilCard = [self createCardRank:rank withSuit:nil];
        PlayingCard *emptyCard = [self createCardRank:rank withSuit:@""];
        PlayingCard *gibberishCard = [self createCardRank:rank withSuit:@"$%&TG$%#"];
        XCTAssertEqual(nilCard.suit, self.defaultCard.suit);
        XCTAssertEqual(emptyCard.suit, self.defaultCard.suit);
        XCTAssertEqual(gibberishCard.suit, self.defaultCard.suit);
    }
}

@end
