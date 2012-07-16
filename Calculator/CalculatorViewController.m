//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Hugo Ferreira on 2012/07/05.
//  Copyright (c) 2012 Mindclick. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorAlgorithmRPN.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL inMiddleOfNumber;
@property (nonatomic,  strong) CalculatorAlgorithmRPN *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize inMiddleOfNumber = _inMiddleOfNumber;
@synthesize brain = _brain;

- (CalculatorAlgorithmRPN *)brain {
    if (!_brain) _brain = [[CalculatorAlgorithmRPN alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    // Ignore duplicate dots: return if already exists
    if ([digit isEqualToString:@"."]) {
        BOOL displayHasPoint = ([self.display.text rangeOfString:@"."].location != NSNotFound);
        if (self.inMiddleOfNumber && displayHasPoint) return;
    }
    
    // Process only the meaningful key presses
    if (self.inMiddleOfNumber) {
        [self appendToDisplay:digit];
    }
    else {
        [self updateDisplay:digit];
        self.inMiddleOfNumber = YES;
    }
}

- (IBAction)operatorPressed:(UIButton *)sender {
    if (self.inMiddleOfNumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultText = [NSString stringWithFormat:@"%g", result];
    
    [self updateDisplay:resultText];
    [self appendToHistory:sender.currentTitle];
    [self appendToHistory:@"="];
    [self appendToHistory:resultText];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]]; 
    [self appendToHistory:self.display.text];
    self.inMiddleOfNumber = NO;
}

- (IBAction)clearAll {
    self.inMiddleOfNumber = NO;
    [self.brain clearStack];
    
    self.display.text = @"0";
    self.history.text = @"";
}

- (IBAction)clearDigit {
    if ([self.display.text length] > 0) {
        [self updateDisplay:[self.display.text substringToIndex:[self.display.text length]-1]];
    }
    if ([self.display.text isEqual:@""]) {
        [self updateDisplay:@"0"];
        self.inMiddleOfNumber = NO;
    }
}

- (void)updateDisplay:(NSString *)text {
    self.display.text = text;
}

- (void)appendToDisplay:(NSString *)text {
    self.display.text = [self.display.text stringByAppendingString:text];
}

- (void)appendToHistory:(NSString *)text {
    self.history.text = [self.history.text stringByAppendingFormat:@" %@", text];
}

- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setHistory:nil];
    [super viewDidUnload];
}

@end
