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

- (void)setFlipsCount:(int)count
{
    _flipsCount = count;
    self.flipsDisplay.text = [NSString stringWithFormat:@"Flips: %d", self.flipsCount];
    NSLog(@"HF: Flips updated to %d", self.flipsCount);
}

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    [sender setTitle:[self.deck drawRandomCard].contents forState:UIControlStateSelected];
    self.flipsCount++;
}

@end

