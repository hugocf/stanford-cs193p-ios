//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/07/22.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingGame.h"
#import "PlayingDeck.h"
#import "GameResult.h"
#import "PlayResult.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsDisplay;
@property (weak, nonatomic) IBOutlet UILabel *scoreDisplay;
@property (weak, nonatomic) IBOutlet UILabel *messageDisplay;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSelector;
@property (weak, nonatomic) IBOutlet UISlider *messageHistory;
@property (nonatomic) int flipsCount;
@property (strong, nonatomic) PlayingGame *game;
@property (strong, nonatomic) GameResult *gameResult;

@end

@implementation CardGameViewController

- (GameResult *)gameResult
{
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] init];
        _gameResult.gameName = self.game.description;
    }
    return _gameResult;
}

- (PlayingGame *)game
{
    if (!_game) _game = [[PlayingGame alloc] initWithCardCount:[self.cardButtons count]
                                                           fromDeck:[[PlayingDeck alloc] init]
                                                         matchCount:(self.gameModeSelector.selectedSegmentIndex)? 3 : 2
                                                     bonusPenalties:(ScoreDefinitions){-1, -2, 4}];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        // Card face
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        // Card back
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0);
        UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
        [cardButton setImage:(card.isFaceUp)? nil : cardBackImage forState:UIControlStateNormal];
        // Card state
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable)? 0.3 : 1.0;
    }
    self.scoreDisplay.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.messageDisplay.text = [[self.game lastPlay] description];
}

- (void)setFlipsCount:(int)count
{
    _flipsCount = count;
    self.flipsDisplay.text = [NSString stringWithFormat:@"Flips: %d", self.flipsCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.gameModeSelector.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    if (sender.isEnabled && !sender.isSelected) {
        self.flipsCount++; // Card flipped up
    }
    self.messageHistory.maximumValue = [[self.game lastPlays] count];
    self.messageHistory.value = [[self.game lastPlays] count];
    self.messageDisplay.alpha = 1.0;
    [self updateUI];
    self.gameResult.score = self.game.score; 
}

- (IBAction)dealGame {
    self.gameModeSelector.enabled = YES;
    self.game = nil;
    self.flipsCount = 0;
    self.messageHistory.maximumValue = self.flipsCount;
    [self updateUI];
    self.gameResult = nil;
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender
{
    self.game.numCardsToMatch = (sender.selectedSegmentIndex)? 3 : 2;
}

- (IBAction)timeTravel:(UISlider *)sender {
    if (sender.maximumValue > 0) {
        int index = (int)[sender value];
        self.messageDisplay.text = (!index)? @"" : [[self.game lastPlays][index - 1] description];
        self.messageDisplay.alpha = (index == sender.maximumValue)? 1.0 : 0.3;
    }
}

@end
