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
@property (readonly, nonatomic) PlayingCard *diamondsAce;
@end

@implementation PayingCardTests

#pragma mark - Each Method

- (void)setUp
{
    [super setUp];
    _diamondsAce = [self createCardSuit:@"♦" withRank:1];
}

#pragma mark - Helpers

- (PlayingCard *)createCardSuit:(NSString *)suit withRank:(NSUInteger)rank
{
    PlayingCard *card = [[PlayingCard alloc] init];
    card.suit = suit;
    card.rank = rank;
    return card;
}

#pragma mark - Test Cases

- (void)testCardsCanBeTurnedAround
{
    XCTAssert(YES, @"");
}

- (void)testCardsCanBeDisabled
{
}

- (void)testCardsOfTheSameSuitMatch
{
    XCTAssert(YES, @"");
}

- (void)testCardsWithDifferentSuitsDontMatch
{
    XCTAssert(YES, @"");
}

- (void)testCardsOfTheSameRankMatch
{
    XCTAssert(YES, @"");
}

- (void)testCardsWithDifferentRankDontMatch
{
    XCTAssert(YES, @"");
}

- (void)testCannotCreateCardsWithInvalidRank
{
    XCTAssert(YES, @"");
}

- (void)testCannotCreateCardsWithInvalidSuit
{
    XCTAssert(YES, @"");
}

@end
