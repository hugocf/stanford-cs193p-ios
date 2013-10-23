//
//  PlayingDeckTests.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/10/17.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlayingDeck.h"
#import "PlayingCard.h"

#pragma mark - Test Support

@interface PlayingDeck (Test)
- (NSMutableArray *)cards;
@end

#pragma mark - Test Suite

@interface PlayingDeckTests : XCTestCase

@end

@implementation PlayingDeckTests

- (void)testFullDeckStartsWithAllTheCards
{
    PlayingDeck *fullDeck = [[PlayingDeck alloc] init];
    NSUInteger cardsInDeck = [fullDeck.cards count];
    NSUInteger totalSuits = [[PlayingCard validSuits] count];
    NSUInteger totalRanks = [PlayingCard maxRank];
    XCTAssertEqual(cardsInDeck, totalSuits * totalRanks);
}

- (void) testDeckDoesNotContainDuplicateCards
{
    PlayingDeck *fullDeck = [[PlayingDeck alloc] init];
    NSUInteger cardsInDeck = [fullDeck.cards count];
    NSUInteger uniqueCards = [[NSSet setWithArray:fullDeck.cards] count];
    XCTAssertEqual(cardsInDeck, uniqueCards);
}

@end
