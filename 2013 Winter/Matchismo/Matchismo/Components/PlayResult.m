//
//  PlayResult.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/24.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "PlayResult.h"

@implementation PlayResult

#pragma mark - Initializers

- (id)initWithCards:(NSArray *)cards outcome:(PlayStatus)result score:(int)points
{
    self = [super init];
    if (self) {
        _cards = cards;
        _outcome = result;
        _score = points;
    }
    return self;
}

- (id)init
{
    return [self initWithCards:nil outcome:0 score:0];
}

#pragma mark - Methods


#pragma mark - NSObject

- (NSString *)outcomeString
{
    NSString *translation = @"";
    switch (self.outcome) {
        case PlayStatusCardFlipped:     translation = @"Flipped"; break;
        case PlayStatusCardsMatch:      translation = @"Matched"; break;
        case PlayStatusCardsMismatch:   translation = @"Didn't match"; break;
    }
    return translation;
}

- (NSString *)description
{
    NSString *cardNames = [self.cards componentsJoinedByString:@" "];
    return [NSString stringWithFormat:@"%@ %@ (%+d)", [self outcomeString], cardNames, self.score];
}

@end
