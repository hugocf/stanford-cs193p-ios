//
//  SetDeckTests.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/10/17.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SetDeck.h"
#import "SetCard.h"

#pragma mark - Test Support

@interface SetDeck (Test)
- (NSMutableArray *)cards;
@end

#pragma mark - Test Suite

@interface SetDeckTests : XCTestCase

@end

@implementation SetDeckTests

- (void)testFullDeckStartsWithAllTheCards
{
    SetDeck *fullDeck = [[SetDeck alloc] init];
    NSUInteger cardsInDeck = [fullDeck.cards count];
    NSUInteger totalNumbers = 3;
    NSUInteger totalSymbols = [[SetCard validSymbols] count];
    NSUInteger totalShadings = CARD_SHADING_TYPE_COUNT;
    NSUInteger totalColors = CARD_COLOR_TYPE_COUNT;
    XCTAssertEqual(cardsInDeck, totalNumbers * totalSymbols * totalShadings * totalColors);
}

- (void) testDeckDoesNotContainDuplicateCards
{
    SetDeck *fullDeck = [[SetDeck alloc] init];
    NSUInteger cardsInDeck = [fullDeck.cards count];
    NSUInteger uniqueCards = [[NSSet setWithArray:fullDeck.cards] count];
    XCTAssertEqual(cardsInDeck, uniqueCards);
}

@end
