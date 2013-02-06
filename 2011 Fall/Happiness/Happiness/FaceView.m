//
//  FaceView.m
//  Happiness
//
//  Created by Hugo Ferreira on 2012/07/19.
//  Copyright (c) 2012 Mindclick. All rights reserved.
//

#import "FaceView.h"

#define FACE_SIZE_FACTOR 0.90
#define EYES_SIZE_FACTOR 0.10
#define EYES_POSITION_H 0.35
#define EYES_POSITION_V 0.35
#define MOUTH_SIZE_FACTOR 0.25
#define MOUTH_POSITION_H 0.45
#define MOUTH_POSITION_V 0.40

@implementation FaceView

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

- (CGFloat)scale
{
    if (!_scale) {
        return FACE_SIZE_FACTOR;
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (_scale != scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged
        || gesture.scale == UIGestureRecognizerStateEnded)
    {
        self.scale *= gesture.scale;
        gesture.scale = 1.0; 
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawCircleAtPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef) context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, 0, 2 * M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //
    // Face...
    //
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
    
    CGFloat size = ((self.bounds.size.width < self.bounds.size.height)? self.bounds.size.width : self.bounds.size.height) / 2;
    size *= self.scale;
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
    
    //
    // Eyes...
    //
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYES_POSITION_H;
    eyePoint.y = midPoint.y - size * EYES_POSITION_V;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYES_SIZE_FACTOR inContext:context];
    
    eyePoint.x = midPoint.x + size * EYES_POSITION_H;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYES_SIZE_FACTOR inContext:context];
    
    //
    // Mouth...
    //
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - size * MOUTH_POSITION_H;
    mouthStart.y = midPoint.y + size * MOUTH_POSITION_V;
    CGPoint mouthStop = mouthStart;
    CGPoint mouthCP1 = mouthStart;
    CGPoint mouthCP2 = mouthStart;
    mouthStop.x = midPoint.x + size * MOUTH_POSITION_H;
    mouthCP1.x = midPoint.x - size * MOUTH_POSITION_H / 3;
    mouthCP2.x = midPoint.x + size * MOUTH_POSITION_H / 3;
    
    // Direction: Happy or Smile?
    float smileDirection = [self.dataSource smileForFaceView:self];
    if (smileDirection <= -1) smileDirection = -1;
    if (smileDirection >= 1) smileDirection = 1;
    
    CGFloat smileOffset = size * MOUTH_SIZE_FACTOR * smileDirection;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthStop.x, mouthStop.y);
    CGContextStrokePath(context);
}

@end
