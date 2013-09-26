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
    
    // Only draw inside the card
    [roundedRect addClip];
    
    // Card color
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    [[UIColor blackColor] setFill];
    [roundedRect stroke]; 
}

@end
