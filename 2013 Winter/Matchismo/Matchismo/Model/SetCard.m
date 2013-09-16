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

#pragma mark - Initialization

- (id)initWithNumber:(int)number
              symbol:(NSString *)symbol
             shading:(ShadingType)shading
               color:(UIColor *)color
{
    self = [super init];
    if (self) {
        // validate params
        if (!(number >= 1 && number <= 3)) return nil;
        if (![[SetCard validSymbols] containsObject:symbol]) return nil;
        if (![[SetCard validColors] containsObject:color]) return nil;
        
        // define the card
        _number = number;
        _symbol = symbol;
        _shading = shading;
        _color = color;
    }
    return self;
}

- (id)init
{
    // "resonable" settings for a default card
    return [self initWithNumber:1
                         symbol:[SetCard validSymbols][0]
                        shading:(ShadingType)[SetCard validShadings][0]
                          color:[SetCard validColors][0]];
}

@end
