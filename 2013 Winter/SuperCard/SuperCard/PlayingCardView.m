//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Hugo Ferreira on 2013/09/26.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView

#pragma mark - Initialization

#define CARD_CORNER_RADIUS 12.0

- (void)setup
{
    ;
}

#pragma mark - Properties

- (void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - NSObject(UIKit)

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Card boundaries
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CARD_CORNER_RADIUS];
    
    // Draw border
    [[UIColor blackColor] setFill];
    [roundedRect stroke];
    
    // White fill + Transparent corners
    [[UIColor whiteColor] setFill];
    // 2 approaches could be used...
    switch (1) {
        case 1:
            // approach #1 (class)
            [roundedRect addClip];      // draw only inside the card
            UIRectFill(self.bounds);    // fill out entire view with white (but gets clipped)
            break;
        case 2:
            // approach #2 (docs)
            [roundedRect fill];         // fills the entire rect
                                        // (so the clipping doesn't matter)
            break;
    }
}

@end
