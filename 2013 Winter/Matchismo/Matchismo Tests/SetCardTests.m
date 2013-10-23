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
                                                   symbol:CardSymbolDiamond
                                                  shading:CardShadingSolid
                                                    color:CardColorRed];
}

#pragma mark - Standard Operations

- (void)/*TODO:*/OFF_testCardsAreAlwaysFacingUp
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

#pragma mark - ...

@end
