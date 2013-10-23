//
//  BaseCardTests.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/10/17.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Card.h"

#pragma mark - Test Support

@interface BaseCardTests_CardSubclass : Card
@end

@implementation BaseCardTests_CardSubclass
@end

#pragma mark - Test Suite


@interface BaseCardTests : XCTestCase

@end

@implementation BaseCardTests

- (void)testCannotInstantiateBaseClass
{
    XCTAssertThrows([[Card alloc] init]);
}

- (void)testCannotInvokeAbstractMethods
{
    BaseCardTests_CardSubclass *card = [[BaseCardTests_CardSubclass alloc] init];
    XCTAssertThrows([card match:@[]]);
}

@end
