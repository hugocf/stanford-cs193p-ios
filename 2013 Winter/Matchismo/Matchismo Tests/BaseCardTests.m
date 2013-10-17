//
//  BaseCardTests.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/10/17.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "TestHelpers.h"

@interface BaseCardTests : XCTestCase

@end

@implementation BaseCardTests

- (void)testCannotInstantiateBaseClass
{
    XCTAssertThrows([[Card alloc] init]);
}

- (void)testCannotInvokeAbstractMethods
{
    CardSubclass *card = [[CardSubclass alloc] init];
    XCTAssertThrows([card match:@[]]);
}

@end
