//
//  SetCard.h
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

extern NSString * const SetCardSymbolDiamond;
extern NSString * const SetCardSymbolSquiggle;
extern NSString * const SetCardSymbolOval;

typedef NS_ENUM(NSInteger, SetCardShadingType) {
    SetCardShadingSolid,
    SetCardShadingStriped,
    SetCardShadingOpen,
    SET_CARD_SHADING_TYPE_COUNT
};

typedef NS_ENUM(NSInteger, SetCardColorType) {
    SetCardColorRed,
    SetCardColorGreen,
    SetCardColorPurple,
    SET_CARD_COLOR_TYPE_COUNT
};

/**
 The Set cards vary in four features: number, symbol, shading, and color.

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
- (id)initWithNumber:(NSUInteger)number
             shading:(SetCardShadingType)shading
               color:(SetCardColorType)color
              symbol:(NSString *)symbol;

/** number = one, two, or three. */
@property (readonly, nonatomic) NSUInteger number;

/** symbol = diamond, squiggle, oval. */
@property (readonly, strong, nonatomic) NSString *symbol;

/** shading = solid, striped, or open. */
@property (readonly, nonatomic) SetCardShadingType shading;

/** color = red, green, or purple. */
@property (readonly, nonatomic) SetCardColorType color;

/** List of NSString symbols allowed for the Set cards. */
+ (NSArray *)validSymbols;

@end
