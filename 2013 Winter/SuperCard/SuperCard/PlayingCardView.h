//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Hugo Ferreira on 2013/09/26.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;

- (void)pinch:(UIGestureRecognizer *)gesture;

@end
