//
//  PlayingCard.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/07/24.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
{}
#pragma mark - Class

+ (NSArray *)validSuits
{
    static NSArray *suits = nil;
    if (!suits) suits = @[@"♥", @"♦", @"♠", @"♣"];
    return suits;
}

+ (NSArray *)validRanks
{
    static NSArray *ranks = nil;
    if (!ranks) ranks = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    return ranks;
}

+ (NSUInteger)maxRank
{
    return [self validRanks].count - 1;
}

#pragma mark - Properties

@synthesize suit = _suit;

- (NSString *)suit
{
    return (_suit)? _suit : @"Ø";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
} 

#pragma mark - Methods

- (NSString *)contents
{
    NSArray *ranks = [PlayingCard validRanks];
    return [ranks[self.rank] stringByAppendingString:self.suit];
}

@end
 