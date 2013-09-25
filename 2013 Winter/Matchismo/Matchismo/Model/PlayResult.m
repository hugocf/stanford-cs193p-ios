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

#pragma mark - NSObject

- (NSString *)description
{
    NSString *cardNames = [self.cards componentsJoinedByString:@" "];
    NSString *whatHappened = @"";
    
    switch (self.outcome) {
        case PlayStatusCardFlipped:     whatHappened = @"Flipped"; break;
        case PlayStatusCardsMatch:      whatHappened = @"Matched"; break;
        case PlayStatusCardsMismatch:   whatHappened = @"Didn't match"; break;
    }
    
    return [NSString stringWithFormat:@"%@ %@ (%+d)", whatHappened, cardNames, self.score];
}

@end
