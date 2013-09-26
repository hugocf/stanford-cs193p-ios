//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Hugo Ferreira on 2013/09/26.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat faceScaleFactor;
@end

@implementation PlayingCardView

#pragma mark - Initialization

#define CARD_CORNER_RADIUS 12.0
#define CARD_CORNER_TEXT_SCALE 0.20
#define CARD_CORNER_TEXT_X 2.0
#define CARD_CORNER_TEXT_Y 2.0
#define DEFAULT_CARD_FACE_SCALE 0.90

- (void)setup
{
    ;
}

#pragma mark - Properties

@synthesize faceScaleFactor = _faceScaleFactor;

- (CGFloat)faceScaleFactor
{
    if (!_faceScaleFactor) _faceScaleFactor = DEFAULT_CARD_FACE_SCALE;
    return _faceScaleFactor;
}

- (void)setFaceScaleFactor:(CGFloat)faceScaleFactor
{
    _faceScaleFactor = faceScaleFactor;
    [self setNeedsDisplay];
}

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

#pragma mark - Methods

- (void)drawCorners
{
    // Typography
    UIFont *textFont = [UIFont systemFontOfSize:self.bounds.size.width * CARD_CORNER_TEXT_SCALE];
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle alloc] init];
    textStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *textAttributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: textStyle};
    // Data
    NSString *cardValue = [NSString stringWithFormat:@"%@\n%@", self.rankAsString, self.suit];
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:cardValue
                                                                     attributes:textAttributes];
    // Drawing
    CGRect textBounts;
    textBounts.origin = CGPointMake(CARD_CORNER_TEXT_X, CARD_CORNER_TEXT_Y);
    textBounts.size = [cornerText size];
    
    [cornerText drawInRect:textBounts]; // top-left corner
    [self pushAndRotatecontext];
    [cornerText drawInRect:textBounts]; // bottom-right corner
    [self popContext];
}

- (void)pushAndRotatecontext
{
    // Push
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    // Move
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    // Rotate
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (NSString *)rankAsString
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
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
    
    if (self.faceUp) {
        // Card centre
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
        if (faceImage) {
            CGRect imageInset = CGRectInset(self.bounds,
                                            self.bounds.size.width * (1.0 - self.faceScaleFactor),
                                            self.bounds.size.height * (1.0 - self.faceScaleFactor));
            [faceImage drawInRect:imageInset];
        }
        // Card corners
        [self drawCorners];
    } else {
        // Card back
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

@end
