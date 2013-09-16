//
//  SetCard.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
{}

#pragma mark - Class

+ (NSArray *)validColors
{
    static NSArray *colors = nil;
    if (!colors) colors = @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];
    return colors;
}

+ (NSArray *)validSymbols
{
    static NSArray *symbols = nil;
    if (!symbols) symbols = @[@"▲", @"●", @"◼"];
    return symbols;
}

+ (NSArray *)validShadings
{
    static NSArray *shades = nil;
    if (!shades) shades = @[@(ShadingSolid), @(ShadingStriped), @(ShadingOpen)];
    return shades;
}

#pragma mark - Properties

- (void)setNumber:(int)number
{
    if (number >= 1 && number <= 3) {
        _number = number;
    }
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (void)setColor:(UIColor *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

@end
