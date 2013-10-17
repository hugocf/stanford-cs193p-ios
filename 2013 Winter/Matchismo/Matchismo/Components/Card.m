//
//  Card.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/07/24.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "Card.h"

@implementation Card

#pragma mark - Abstract

- (int)match:(NSArray *)otherCards
{
    RaiseInvalidAbstractInvocation();
    return 0;
}

#pragma mark - Initialization

- (id)init
{
    RaiseInvalidAbstractInstantiationForClass([Card class]);
    self = [super init];
    return self;
}

#pragma mark - Methods

- (NSString *)description
{
    return self.contents;
}

@end
