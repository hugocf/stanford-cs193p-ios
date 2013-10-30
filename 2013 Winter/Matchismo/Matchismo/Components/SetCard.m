//
//  SetCard.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "SetCard.h"

NSString * const CardSymbolDiamond = @"▲";
NSString * const CardSymbolSquiggle = @"■";
NSString * const CardSymbolOval = @"●";

@implementation SetCard

#pragma mark - Class

/** Validates if a property of the cards is all the same or all distinct. */
+ (BOOL)allSameOrDifferent:(NSString *)property forArray:(NSArray *)cards
{
    return ([self allElementsInArray:cards haveTheSame:property])
        || ([self allElementsInArray:cards haveDistinct:property]);
}

/**
 If after transforming the array into a Set made out of values from the property
 there is only 1 element in the Set, then they were all the same value.
 */
+ (BOOL)allElementsInArray:(NSArray *)cards haveTheSame:(NSString *)property
{
    return (1 == [[NSSet setWithArray:[cards valueForKey:property]] count]);
}

/**
 If the cards list is the same length as the Set made out of values from the property,
 then, since sets only contain unique values, all the cards are different and distinct
 for that porperty.
 */
+ (BOOL)allElementsInArray:(NSArray *)cards haveDistinct:(NSString *)property
{
    return (cards.count == [[NSSet setWithArray:[cards valueForKey:property]] count]);
}

+ (NSArray *)validSymbols
{
    static NSArray *symbols = nil;
    if (!symbols) symbols = @[CardSymbolDiamond, CardSymbolOval, CardSymbolSquiggle];
    return symbols;
}

#pragma mark - Initialization

/* TODO: Refactor into a more natural reading order = oneSolidRedTriangle */
- (id)initWithNumber:(int)number
              symbol:(NSString *)symbol
             shading:(CardShadingType)shading
               color:(CardColorType)color
{
    self = [super init];
    if (self) {
        // validate params
        if (!(number >= 1 && number <= 3)) return nil;
        if (![[SetCard validSymbols] containsObject:symbol]) return nil;
        
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
                        shading:CardShadingSolid
                          color:CardColorRed];
}

#pragma mark - Properties

- (BOOL)isFaceUp
{
    if (!super.isFaceUp) super.faceup = YES;
    return super.isFaceUp;
}

- (void)setFaceup:(BOOL)faceup
{
    if (faceup) super.faceup = faceup;
}

#pragma mark - Methods

- (NSString *)contents
{
    return [@"" stringByPaddingToLength:self.number withString:self.symbol startingAtIndex:0];
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // Are all other cards a SetCard?
    BOOL(^isSameClass)(id, NSUInteger, BOOL*) = ^(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass:[SetCard class]];
    };
    BOOL isOnlySetCards = (otherCards.count == [otherCards indexesOfObjectsPassingTest:isSameClass].count);
    
    // Compare with several SetCards...
    if (otherCards.count > 0 && isOnlySetCards) {
        NSArray *allCards = [otherCards arrayByAddingObject:self];
        
        // Penalise if some feature didn't match
        for (NSString *property in @[@"number", @"symbol", @"shading", @"color"]) {
            if (![SetCard allSameOrDifferent:property forArray:allCards]) {
                score--;
            }
        }
        // Give points for matching a set
        if (!(score < 0)) score = 3;
    }
    return score;
}

@end
