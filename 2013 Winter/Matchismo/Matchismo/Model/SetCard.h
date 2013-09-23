//
//  SetCard.h
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

typedef enum {
    ShadingSolid,
    ShadingStriped,
    ShadingOpen,
    CARD_SHADING_TYPE_COUNT
} ShadingType;

/**
 The Set cards vary in four features: number, symbol, shading, and color.
 
 // TODO How to make the paragraphs split in Xcode 5 quick help?
 // TODO How to separate the "overview/summary" from the "discussion"?
 A set consists of three cards which satisfy all of these conditions:
 
 - They all have the same number, or they have three different numbers.
 - They all have the same symbol, or they have three different symbols.
 - They all have the same shading, or they have three different shadings.
 - They all have the same color, or they have three different colors.
 
 The rules of Set are summarized by: If you can sort a group of three cards
 into "Two of ____ and one of _____," then it is not a set.
 
 For example, these three cards form a set:
 
 - One red striped diamond
 - Two red solid diamonds
 - Three red open diamonds
 
 Given any two cards from the deck, there will be one and only one other 
 card that forms a set with them.
 */
@interface SetCard : Card

/** Designated initializer. */
- (id)initWithNumber:(int)number
              symbol:(NSString *)symbol
             shading:(ShadingType)shading
               color:(UIColor *)color;  // FIXME: should be defined as enum type to keep the model UIKit independent

/** number = one, two, or three. */
@property (readonly, nonatomic) int number;

/** symbol = diamond, squiggle, oval. */
@property (readonly, strong, nonatomic) NSString *symbol;

/** shading = solid, striped, or open. */
@property (readonly, nonatomic) ShadingType shading;

/** color = red, green, or purple. */
@property (readonly, strong, nonatomic) UIColor *color;

/** List of UIColors allowed for the Set cards. */
+ (NSArray *)validColors;

/** List of NSString symbols allowed for the Set cards. */
+ (NSArray *)validSymbols;

@end
