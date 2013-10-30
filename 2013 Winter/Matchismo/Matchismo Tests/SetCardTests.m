//
//  SetCardTests.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/10/17.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SetCard.h"

@interface SetCardTests : XCTestCase
@property (readonly, nonatomic) SetCard *defaultCard;
@property (readonly, nonatomic) SetCard *oneSolidRedDiamond;
@end

@implementation SetCardTests

#pragma mark - Each Method

- (void)setUp
{
    [super setUp];
    _defaultCard = [[SetCard alloc] init];
    _oneSolidRedDiamond = [[SetCard alloc] initWithNumber:1
                                                  shading:CardShadingSolid
                                                    color:CardColorRed
                                                   symbol:CardSymbolDiamond];
}

#pragma mark - Helpers

- (SetCard *)createCardWithNumber:(int)number
                          shading:(CardShadingType)shading
                            color:(CardColorType)color
                           symbol:(NSString *)symbol
{
    return [[SetCard alloc] initWithNumber:number shading:shading color:color symbol:symbol];
}

#pragma mark - Standard Card Operations

-(void)testCardsAreAlwaysFacingUp
{
    XCTAssertTrue(self.oneSolidRedDiamond.isFaceUp, @"Cards should start face up");
    self.oneSolidRedDiamond.faceup = NO;
    XCTAssertTrue(self.oneSolidRedDiamond.isFaceUp, @"Cards should always remain face up");
}

- (void)testCardsCanBeDisabled
{
    XCTAssertFalse(self.oneSolidRedDiamond.isUnplayable, @"Cards should start being playable");
    self.oneSolidRedDiamond.unplayable = YES;
    XCTAssertTrue(self.oneSolidRedDiamond.isUnplayable, @"Cards must be able to be disabled for the game");
}

#pragma mark - Creating Cards

- (void)testCannotCreateCardsWithInvalidNumber
{
    SetCard *card = [[SetCard alloc] initWithNumber:0
                                            shading:CardShadingSolid
                                              color:CardColorRed
                                             symbol:CardSymbolDiamond];
    XCTAssertNil(card, @"Must not be able to create an invalid card");
}

- (void)testCannotCreateCardsWithInvalidSymbol
{
    SetCard *card = [[SetCard alloc] initWithNumber:1
                                            shading:CardShadingSolid
                                              color:CardColorRed
                                             symbol:@"FooBar"];
    XCTAssertNil(card, @"Must not be able to create an invalid card");
}

- (void)testCannotCreateCardsWithInvalidShading
{
    SetCard *card1 = [[SetCard alloc] initWithNumber:1
                                             shading:CARD_SHADING_TYPE_COUNT
                                               color:CardColorRed
                                              symbol:CardSymbolDiamond];
    SetCard *card2 = [[SetCard alloc] initWithNumber:1
                                             shading:1000
                                               color:CardColorRed
                                              symbol:CardSymbolDiamond];
    XCTAssertNil(card1, @"Must not be able to create an invalid card");
    XCTAssertNil(card2, @"Must not be able to create an invalid card");
}

- (void)testCannotCreateCardsWithInvalidColor
{
    SetCard *card1 = [[SetCard alloc] initWithNumber:1
                                             shading:CardShadingSolid
                                               color:CARD_COLOR_TYPE_COUNT
                                              symbol:CardSymbolDiamond];
    SetCard *card2 = [[SetCard alloc] initWithNumber:1
                                             shading:CardShadingSolid
                                               color:1000
                                              symbol:CardSymbolDiamond];
    XCTAssertNil(card1, @"Must not be able to create an invalid card");
    XCTAssertNil(card2, @"Must not be able to create an invalid card");
}

#pragma mark - Matching Cards


- (void)testSetsCanHaveAllTheSameNumber
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:1 shading:CardShadingOpen    color:CardColorGreen  symbol:CardSymbolOval],
      [self createCardWithNumber:1 shading:CardShadingStriped color:CardColorPurple symbol:CardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveAllTheSameShading
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:CardShadingSolid color:CardColorGreen  symbol:CardSymbolOval],
      [self createCardWithNumber:3 shading:CardShadingSolid color:CardColorPurple symbol:CardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveAllTheSameColor
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:CardShadingOpen    color:CardColorRed symbol:CardSymbolOval],
      [self createCardWithNumber:3 shading:CardShadingStriped color:CardColorRed symbol:CardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveAllTheSameSymbol
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:CardShadingOpen    color:CardColorGreen  symbol:CardSymbolDiamond],
      [self createCardWithNumber:3 shading:CardShadingStriped color:CardColorPurple symbol:CardSymbolDiamond],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveThreeDifferentNumbers
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:CardShadingSolid color:CardColorRed symbol:CardSymbolDiamond],
      [self createCardWithNumber:3 shading:CardShadingSolid color:CardColorRed symbol:CardSymbolDiamond],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveThreeDifferentShadings
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:1 shading:CardShadingOpen    color:CardColorRed symbol:CardSymbolDiamond],
      [self createCardWithNumber:1 shading:CardShadingStriped color:CardColorRed symbol:CardSymbolDiamond],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveThreeDifferentColors
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:1 shading:CardShadingSolid color:CardColorGreen  symbol:CardSymbolDiamond],
      [self createCardWithNumber:1 shading:CardShadingSolid color:CardColorPurple symbol:CardSymbolDiamond],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveThreeDifferentSymbols
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:1 shading:CardShadingSolid color:CardColorRed symbol:CardSymbolOval],
      [self createCardWithNumber:1 shading:CardShadingSolid color:CardColorRed symbol:CardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCannotHaveTwoOfTheSameNumber
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:CardShadingOpen    color:CardColorGreen  symbol:CardSymbolOval],
      [self createCardWithNumber:2 shading:CardShadingStriped color:CardColorPurple symbol:CardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score < 0, @"Mismatching card sets must return a negative score");
}

- (void)testSetsCannotHaveTwoOfTheSameShading
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:CardShadingOpen color:CardColorGreen  symbol:CardSymbolOval],
      [self createCardWithNumber:3 shading:CardShadingOpen color:CardColorPurple symbol:CardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score < 0, @"Mismatching card sets must return a negative score");
}

- (void)testSetsCannotHaveTwoOfTheSameColor
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:CardShadingOpen    color:CardColorGreen  symbol:CardSymbolOval],
      [self createCardWithNumber:3 shading:CardShadingStriped color:CardColorGreen symbol:CardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score < 0, @"Mismatching card sets must return a negative score");
}

- (void)testSetsCannotHaveTwoOfTheSameSymbol
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:CardShadingOpen    color:CardColorGreen  symbol:CardSymbolOval],
      [self createCardWithNumber:3 shading:CardShadingStriped color:CardColorPurple symbol:CardSymbolOval],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score < 0, @"Mismatching card sets must return a negative score");
}

@end
