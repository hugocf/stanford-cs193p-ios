//
//  BaseDeckTests.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/10/17.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestHelpers.h"

#pragma mark - Test Support

@interface Deck (Test)
- (NSMutableArray *)cards;
@end

#pragma mark - Test Suite

@interface BaseDeckTests : XCTestCase

@end

@implementation BaseDeckTests

#pragma mark - Helpers

- (void)createCards:(NSUInteger)howMany inDeck:(Deck *)deck
{
    for (NSUInteger i = 0; i < howMany; i++) {
        Card *card = [[CardSubclass alloc] init];
        [deck addCard:card atTop:NO];
    }
}

- (void)drawAllCardsInDeck:(Deck *)deck
{
    NSUInteger numberOfCards = [deck.cards count];
    for (NSUInteger i = 0; i < numberOfCards; i++) {
        [deck drawRandomCard];
    }
}

#pragma mark - Test Cases

- (void)testCardsCanBeAdddedAtBothEnds
{
    Card *cardBottom = [[CardSubclass alloc] init];
    Card *cardTop = [[CardSubclass alloc] init];
    Deck *deck = [[Deck alloc] init];
    [self createCards:10 inDeck:deck];
    
    [deck addCard:cardBottom atTop:NO];
    [deck addCard:cardTop atTop:YES];
    NSUInteger lastCardIndex = [deck.cards count]-1;
    XCTAssert(cardBottom == deck.cards[lastCardIndex], @"Bottom card must be the last one");
    XCTAssert(cardTop == deck.cards[0], @"Top card must be the first one");
}

- (void)testDrawCardsFromEmptyDeckDoesntCrash
{
    Card *drawCard;
    Deck *emptyDeck = [[Deck alloc] init];
    
    XCTAssertNoThrow(drawCard = [emptyDeck drawRandomCard]);
    XCTAssertNil(drawCard);
}

- (void)testCanDrawFromSingleCardDeck
{
    Card *drawCard;
    Deck *singleCardDeck = [[Deck alloc] init];
    [self createCards:1 inDeck:singleCardDeck];
    
    XCTAssertNoThrow(drawCard = [singleCardDeck drawRandomCard]);
    XCTAssertNotNil(drawCard);
    BOOL deckIsEmpty = ![singleCardDeck.cards count];
    XCTAssertTrue(deckIsEmpty);
}

- (void)testCannotDrawMoreCardsThanExistInDeck
{
    Card *drawCard;
    Deck *manyCardsDeck = [[Deck alloc] init];
    [self createCards:2 inDeck:manyCardsDeck];
    
    XCTAssertNoThrow([self drawAllCardsInDeck:manyCardsDeck]);
    XCTAssertNoThrow(drawCard = [manyCardsDeck drawRandomCard]);
    XCTAssertNil(drawCard);
}

@end
