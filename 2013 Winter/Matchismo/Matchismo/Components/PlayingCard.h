//
//  PlayingCard.h
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/07/24.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end

