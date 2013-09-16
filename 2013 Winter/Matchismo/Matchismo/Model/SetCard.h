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
    ShadingOpen
} ShadingType;

/**
 The Set cards vary in four features: number, symbol, shading, and color.
*/
@interface SetCard : Card

/** number = one, two, or three. */
@property (nonatomic) int number;

/** symbol = diamond, squiggle, oval. */
@property (strong, nonatomic) NSString *symbol;

/** shading = solid, striped, or open. */
@property (nonatomic) ShadingType shading;

/** color = red, green, or purple. */
@property (strong, nonatomic) UIColor *color;

/** List of UIColors allowed for the Set cards. */
+ (NSArray *)validColors;

/** List of ShadingType enums allowed for the Set cards. */
+ (NSArray *)validShadings;

/** List of NSString symbols allowed for the Set cards. */
+ (NSArray *)validSymbols;

@end
