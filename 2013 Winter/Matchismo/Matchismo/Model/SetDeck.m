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
                for (CardShadingType shade = 0; shade < CARD_SHADING_TYPE_COUNT; shade++) {
                    for (UIColor *color in [SetCard validColors]) {
                        SetCard *card = [[SetCard alloc] initWithNumber:number
                                                                 symbol:symbol
                                                                shading:shade
                                                                  color:color];
                        if (card) [self addCard:card atTop:YES];
                    }
                }
            }
            
        }
    }
    return self;
}

@end
