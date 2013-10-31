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
#import "PlayResult.h"

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
    if (!_game) _game = [[SetMatchingGame alloc] initWithCardCount:[super.cardButtons count]
                                                           fromDeck:[[SetDeck alloc] init]
                                                         matchCount:3
                                                    bonusPenalties:(ScoreDefinitions){-3, -3, 4}];
    return _game;
}

#pragma mark - Methods

- (NSAttributedString *)attributedStringForCard:(SetCard *)card
{
    UIColor *cardColor, *fillColor, *strokeColor;
    NSNumber *strokeWidth;
    // color
    switch (card.color) {
        case CardColorPurple:
            cardColor = [UIColor purpleColor];
            break;
        case CardColorGreen:
            cardColor = [UIColor greenColor];
            break;
        case CardColorRed:   // follow-through
        default:
            cardColor = [UIColor redColor];
            break;
    }
    // shading
    switch (card.shading) {
        case CardShadingOpen:
            fillColor = strokeColor = cardColor;
            strokeWidth = @5;
            break;
        case CardShadingStriped:
            fillColor = [cardColor colorWithAlphaComponent:0.10f];
            strokeColor = cardColor;
            strokeWidth = @-5;
            break;
        case CardShadingSolid:  // follow-through
        default:
            fillColor = strokeColor = cardColor;
            strokeWidth = @0;
            break;
    }
    // compose
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: fillColor,
                                 NSStrokeColorAttributeName: strokeColor,
                                 NSStrokeWidthAttributeName: strokeWidth};
    
    return [[NSAttributedString alloc] initWithString:card.contents
                                           attributes:attributes];
}

- (NSAttributedString *)attributedStringForResult:(PlayResult *)result
{
    NSMutableAttributedString *finalText = [[NSMutableAttributedString alloc] init];
    if (result) {
        // outcome
        NSAttributedString *resultText = [[NSAttributedString alloc] initWithString:[result outcomeString]];
        // cards
        NSMutableAttributedString *cardsText = [[NSMutableAttributedString alloc] init];
        [result.cards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [cardsText appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
            [cardsText appendAttributedString:[self attributedStringForCard:(SetCard *)obj]];
        }];
        // score
        NSAttributedString *scoreText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%+d)", result.score]];
        // compose
        [finalText appendAttributedString:resultText];
        [finalText appendAttributedString:cardsText];
        [finalText appendAttributedString:scoreText];
        // defaults
        UIFont *font = [UIFont systemFontOfSize:14.0]; // 12.0 = default system font size
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [finalText addAttributes:@{NSFontAttributeName: font,
                                   NSParagraphStyleAttributeName: paragraphStyle}
                           range:(NSRange){0, [finalText length]}];
    }
    return finalText;
}

- (IBAction)timeTravel:(UISlider *)sender {
    if (sender.maximumValue > 0) {
        int index = (int)[sender value];
        if (index) {
            self.messageDisplay.attributedText = [self attributedStringForResult:[self.game lastPlays][index - 1]];
            self.messageDisplay.alpha = (index == sender.maximumValue)? 1.0 : 0.3;
        }
    }
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setAttributedTitle:[self attributedStringForCard:card] forState:UIControlStateNormal];
        
        // Style the button
        if (card.isUnplayable) {
            cardButton.alpha = 0.0;
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
    // Update scoreboard
    self.scoreDisplay.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.messageDisplay.attributedText = [self attributedStringForResult:[self.game lastPlay]];
}

@end
