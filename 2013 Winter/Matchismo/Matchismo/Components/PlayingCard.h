//
//  PlayingCard.h
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/07/24.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

extern NSString * const PlayingCardSymbolHearts;
extern NSString * const PlayingCardSymbolDiamonds;
extern NSString * const PlayingCardSymbolSpades;
extern NSString * const PlayingCardSymbolClubs;

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end

