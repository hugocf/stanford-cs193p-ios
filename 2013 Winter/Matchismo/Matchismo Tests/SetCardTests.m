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

#pragma mark - Each Test

- (void)setUp
{
    [super setUp];
    _defaultCard = [[SetCard alloc] init];
    _oneSolidRedDiamond = [[SetCard alloc] initWithNumber:1
                                                  shading:SetCardShadingSolid
                                                    color:SetCardColorRed
                                                   symbol:SetCardSymbolDiamond];
}

#pragma mark - Helpers

- (SetCard *)createCardWithNumber:(NSUInteger)number
                          shading:(SetCardShadingType)shading
                            color:(SetCardColorType)color
                           symbol:(NSString *)symbol
{
    return [[SetCard alloc] initWithNumber:number shading:shading color:color symbol:symbol];
}

#pragma mark - Standard Card Operations

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
                                            shading:SetCardShadingSolid
                                              color:SetCardColorRed
                                             symbol:SetCardSymbolDiamond];
    XCTAssertNil(card, @"Must not be able to create an invalid card");
}

- (void)testCannotCreateCardsWithInvalidSymbol
{
    SetCard *card = [[SetCard alloc] initWithNumber:1
                                            shading:SetCardShadingSolid
                                              color:SetCardColorRed
                                             symbol:@"FooBar"];
    XCTAssertNil(card, @"Must not be able to create an invalid card");
}

- (void)testCannotCreateCardsWithInvalidShading
{
    SetCard *card1 = [[SetCard alloc] initWithNumber:1
                                             shading:SET_CARD_SHADING_TYPE_COUNT
                                               color:SetCardColorRed
                                              symbol:SetCardSymbolDiamond];
    SetCard *card2 = [[SetCard alloc] initWithNumber:1
                                             shading:1000
                                               color:SetCardColorRed
                                              symbol:SetCardSymbolDiamond];
    XCTAssertNil(card1, @"Must not be able to create an invalid card");
    XCTAssertNil(card2, @"Must not be able to create an invalid card");
}

- (void)testCannotCreateCardsWithInvalidColor
{
    SetCard *card1 = [[SetCard alloc] initWithNumber:1
                                             shading:SetCardShadingSolid
                                               color:SET_CARD_COLOR_TYPE_COUNT
                                              symbol:SetCardSymbolDiamond];
    SetCard *card2 = [[SetCard alloc] initWithNumber:1
                                             shading:SetCardShadingSolid
                                               color:1000
                                              symbol:SetCardSymbolDiamond];
    XCTAssertNil(card1, @"Must not be able to create an invalid card");
    XCTAssertNil(card2, @"Must not be able to create an invalid card");
}

#pragma mark - Matching Cards


- (void)testSetsCanHaveAllTheSameNumber
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:1 shading:SetCardShadingOpen    color:SetCardColorGreen  symbol:SetCardSymbolOval],
      [self createCardWithNumber:1 shading:SetCardShadingStriped color:SetCardColorPurple symbol:SetCardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveAllTheSameShading
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:SetCardShadingSolid color:SetCardColorGreen  symbol:SetCardSymbolOval],
      [self createCardWithNumber:3 shading:SetCardShadingSolid color:SetCardColorPurple symbol:SetCardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveAllTheSameColor
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:SetCardShadingOpen    color:SetCardColorRed symbol:SetCardSymbolOval],
      [self createCardWithNumber:3 shading:SetCardShadingStriped color:SetCardColorRed symbol:SetCardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveAllTheSameSymbol
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:SetCardShadingOpen    color:SetCardColorGreen  symbol:SetCardSymbolDiamond],
      [self createCardWithNumber:3 shading:SetCardShadingStriped color:SetCardColorPurple symbol:SetCardSymbolDiamond],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveThreeDifferentNumbers
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:SetCardShadingSolid color:SetCardColorRed symbol:SetCardSymbolDiamond],
      [self createCardWithNumber:3 shading:SetCardShadingSolid color:SetCardColorRed symbol:SetCardSymbolDiamond],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveThreeDifferentShadings
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:1 shading:SetCardShadingOpen    color:SetCardColorRed symbol:SetCardSymbolDiamond],
      [self createCardWithNumber:1 shading:SetCardShadingStriped color:SetCardColorRed symbol:SetCardSymbolDiamond],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveThreeDifferentColors
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:1 shading:SetCardShadingSolid color:SetCardColorGreen  symbol:SetCardSymbolDiamond],
      [self createCardWithNumber:1 shading:SetCardShadingSolid color:SetCardColorPurple symbol:SetCardSymbolDiamond],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCanHaveThreeDifferentSymbols
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:1 shading:SetCardShadingSolid color:SetCardColorRed symbol:SetCardSymbolOval],
      [self createCardWithNumber:1 shading:SetCardShadingSolid color:SetCardColorRed symbol:SetCardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score > 0, @"Matching card sets must return a positive score");
}

- (void)testSetsCannotHaveTwoOfTheSameNumber
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:SetCardShadingOpen    color:SetCardColorGreen  symbol:SetCardSymbolOval],
      [self createCardWithNumber:2 shading:SetCardShadingStriped color:SetCardColorPurple symbol:SetCardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score < 0, @"Mismatching card sets must return a negative score");
}

- (void)testSetsCannotHaveTwoOfTheSameShading
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:SetCardShadingOpen color:SetCardColorGreen  symbol:SetCardSymbolOval],
      [self createCardWithNumber:3 shading:SetCardShadingOpen color:SetCardColorPurple symbol:SetCardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score < 0, @"Mismatching card sets must return a negative score");
}

- (void)testSetsCannotHaveTwoOfTheSameColor
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:SetCardShadingOpen    color:SetCardColorGreen  symbol:SetCardSymbolOval],
      [self createCardWithNumber:3 shading:SetCardShadingStriped color:SetCardColorGreen symbol:SetCardSymbolSquiggle],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score < 0, @"Mismatching card sets must return a negative score");
}

- (void)testSetsCannotHaveTwoOfTheSameSymbol
{
    NSArray *otherCards =
    @[
      [self createCardWithNumber:2 shading:SetCardShadingOpen    color:SetCardColorGreen  symbol:SetCardSymbolOval],
      [self createCardWithNumber:3 shading:SetCardShadingStriped color:SetCardColorPurple symbol:SetCardSymbolOval],
      ];
    int score = [self.oneSolidRedDiamond match:otherCards];
    XCTAssert(score < 0, @"Mismatching card sets must return a negative score");
}

@end
