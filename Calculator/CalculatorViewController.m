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

@property (nonatomic) BOOL hasDataPending;
@property (nonatomic,  strong) CalculatorAlgorithmRPN *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize hasDataPending = _hasDataPending;
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
        if (self.hasDataPending && displayHasPoint) return;
    }
    
    [self updateDisplay:digit shouldAppend:self.hasDataPending];
    self.hasDataPending = YES;
}

- (IBAction)operatorPressed:(UIButton *)sender {
    if (self.hasDataPending) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultText = [NSString stringWithFormat:@"%g", result];
    
    [self updateDisplay:resultText];
    [self updateHistory:[NSString stringWithFormat:@"%@ = %@", sender.currentTitle, resultText]];
}

- (IBAction)enterPressed {
    BOOL isVariable = ([self.display.text rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound);
    
    if (isVariable)  {
        [self.brain pushVariable:self.display.text];
    } else  {
        [self.brain pushOperand:[self.display.text doubleValue]];   
    }
    self.hasDataPending = NO;
    
    [self updateHistory:self.display.text];
}

- (IBAction)clearAll {
    [self.brain clearStack];
    self.hasDataPending = NO;
    
    [self updateDisplay:@"0"];
    self.history.text = @"";
}

- (IBAction)clearDigit {
    if ([self.display.text length] > 0) {
        [self updateDisplay:[self.display.text substringToIndex:[self.display.text length]-1]];
    }
    if ([self.display.text isEqual:@""]) {
        [self updateDisplay:@"0"];
        self.hasDataPending = NO;
    }
}

- (IBAction)variablePressed:(UIButton *)sender {
    [self updateDisplay:sender.currentTitle];
    self.hasDataPending = YES;
}

- (void)updateDisplay:(NSString *)text {
    [self updateDisplay:text shouldAppend:NO];
}

- (void)updateDisplay:(NSString *)text shouldAppend:(BOOL)shouldAppend {
    if (shouldAppend)
        self.display.text = [self.display.text stringByAppendingString:text];
    else
        self.display.text = text;
}

- (void)updateHistory:(NSString *)text {
    self.history.text = [self.history.text stringByAppendingFormat:@" %@", text];
}

- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setHistory:nil];
    [super viewDidUnload];
}

@end
