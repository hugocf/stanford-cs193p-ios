//
//  SetDeck.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck

- (id)init
{
    self = [super init];
    if (self) {
        for (int number = 1; number <= 3; number++) {
            for (NSString *symbol in [SetCard validSymbols]) {
                for (NSNumber *shade in [SetCard validShadings]) {
                    for (UIColor *color in [SetCard validColors]) {
                        // Create an single card
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = (ShadingType)shade;
                        card.color = color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
            
        }
    }
    return self;
}

@end
