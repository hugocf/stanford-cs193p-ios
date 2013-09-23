//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetMatchingGame.h"
#import "SetDeck.h"

@interface CardGameViewController ()
// Make it visible from the subclass?
@property (strong, nonatomic) NSArray *cardButtons;
@property (weak, nonatomic) UILabel *scoreDisplay;
@property (weak, nonatomic) UILabel *messageDisplay;
@end

@implementation SetGameViewController

#pragma mark - Properties

- (CardMatchingGame *)game
{
    if (!_game) _game = [[SetMatchingGame alloc] initWithCardCount:super.cardButtons.count
                                                           fromDeck:[[SetDeck alloc] init]
                                                         matchCards:3];
    return _game;
}

#pragma mark - Methods

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        // Style the title
        UIFont *font = [UIFont systemFontOfSize:14.0]; // 12.0 = default system font size
        UIColor *fillColor = card.color;
        UIColor *strokeColor = card.color;
        NSNumber *strokeWidth = @0;  // default to solid
        
        switch (card.shading) {
            case ShadingOpen:
                strokeWidth = @5;
                break;
            case ShadingStriped:
                fillColor = [card.color colorWithAlphaComponent:0.10];
                strokeWidth = @-5;
                break;
            case ShadingSolid:  // follow-through
            default: ;          // do nothing
        }
        
        // Set title with the given attributes
        NSDictionary *attributes = @{ NSFontAttributeName: font,
                                      NSForegroundColorAttributeName: fillColor,
                                      NSStrokeColorAttributeName: strokeColor,
                                      NSStrokeWidthAttributeName: strokeWidth };
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:card.contents
                                                                    attributes:attributes];
        [cardButton setAttributedTitle:title forState:UIControlStateNormal];
        
        // Style the button
        if (card.isUnplayable) {
            cardButton.alpha = 0.3;
            [cardButton setBackgroundColor:[UIColor lightGrayColor]];
        } else if (card.isFaceUp) {
            cardButton.alpha = 0.75;
            [cardButton setBackgroundColor:[UIColor yellowColor]];
        } else {
            cardButton.alpha = 1.0;
            [cardButton setBackgroundColor:[UIColor clearColor]];
        }
        
        // Set button state
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
    }
    self.scoreDisplay.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.messageDisplay.text = self.game.lastMessage; // FIXME: Status message also needs styling?
}

@end
