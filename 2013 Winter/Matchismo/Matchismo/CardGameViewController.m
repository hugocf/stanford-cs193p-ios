//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/07/22.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingDeck.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsDisplay;
@property (nonatomic) int flipsCount;
@property (strong, nonatomic) PlayingDeck *deck;

@end

@implementation CardGameViewController

- (PlayingDeck *)deck
{
    if (!_deck) _deck = [[PlayingDeck alloc] init];
    return _deck;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    for (UIButton *cardButton in cardButtons) {
        Card *card = [self.deck drawRandomCard];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
    }
}

- (void)setFlipsCount:(int)count
{
    _flipsCount = count;
    self.flipsDisplay.text = [NSString stringWithFormat:@"Flips: %d", self.flipsCount];
    NSLog(@"HF: Flips updated to %d", self.flipsCount);
}

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    self.flipsCount++;
}

@end

