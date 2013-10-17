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
@property (readonly, nonatomic) SetCard *oneSolidRedTriangle;
@end

@implementation SetCardTests

#pragma mark - Each Method

- (void)setUp
{
    [super setUp];
    _defaultCard = [[SetCard alloc] init];
    _oneSolidRedTriangle = [[SetCard alloc] initWithNumber:1
                                                    symbol:@"▲"
                                                   shading:CardShadingSolid
                                                    color:CardColorRed];
}

#pragma mark - Standard Operations

- (void)/*TODO:*/OFF_testCardsAreAlwaysFacingUp
{
    XCTAssertTrue(self.oneSolidRedTriangle.isFaceUp, @"Cards should start face up");
    self.oneSolidRedTriangle.faceup = NO;
    XCTAssertTrue(self.oneSolidRedTriangle.isFaceUp, @"Cards should always remain face up");
}

- (void)testCardsCanBeDisabled
{
    XCTAssertFalse(self.oneSolidRedTriangle.isUnplayable, @"Cards should start being playable");
    self.oneSolidRedTriangle.unplayable = YES;
    XCTAssertTrue(self.oneSolidRedTriangle.isUnplayable, @"Cards must be able to be disabled for the game");
}

#pragma mark - ...

@end
