//
//  Deck.h
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/07/24.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)yn;
- (Card *)drawRandomCard;

@end
