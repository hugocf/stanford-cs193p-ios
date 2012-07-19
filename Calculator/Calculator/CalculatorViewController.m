//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Hugo Ferreira on 2012/07/05.
//  Copyright (c) 2012 Mindclick. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorAlgorithmRPN.h"
#define random_float(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber) 

@interface CalculatorViewController ()

@property (nonatomic) BOOL hasDataPending;
@property (nonatomic,  strong) CalculatorAlgorithmRPN *brain;
@property (nonatomic) NSDictionary *testVariableValues;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize variables = _variables;
@synthesize hasDataPending = _hasDataPending;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorAlgorithmRPN *)brain
{
    if (!_brain) _brain = [[CalculatorAlgorithmRPN alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    
    // Ignore duplicate dots: return if already exists
    if ([digit isEqualToString:@"."]) {
        BOOL displayHasPoint = ([self.display.text rangeOfString:@"."].location != NSNotFound);
        if (self.hasDataPending && displayHasPoint) return;
    }
    
    [self updateDisplay:digit shouldAppend:self.hasDataPending];
    self.hasDataPending = YES;
}

- (IBAction)operatorPressed:(UIButton *)sender
{
    if (self.hasDataPending) [self enterPressed];
    [self.brain pushOperation:sender.currentTitle];
    [self runProgram];
}

- (IBAction)enterPressed
{
    if ([CalculatorAlgorithmRPN isVariable:self.display.text])  {
        [self.brain pushVariable:self.display.text];
    } else  {
        [self.brain pushOperand:[self.display.text doubleValue]];   
    }
    self.hasDataPending = NO;
    
    [self updateHistory];
}

- (IBAction)clearAll
{
    [self.brain clearStack];
    self.testVariableValues = nil;
    self.hasDataPending = NO;
    
    [self updateDisplay:@"0"];
    [self updateHistory];
    [self updateVariables];
}

- (IBAction)clearLast
{
    if (self.hasDataPending) {
        [self updateDisplay:[self.display.text substringToIndex:[self.display.text length]-1]];
        if ([self.display.text isEqual:@""]) {
            [self updateDisplay:@"0"];
            self.hasDataPending = NO;
        }
    } else {
        [self.brain clearTopOfStack];
        [self runProgram];
    }    
}

- (IBAction)variablePressed:(UIButton *)sender
{
    if (self.hasDataPending) [self enterPressed];
    [self updateDisplay:sender.currentTitle];
    [self enterPressed];
    [self updateVariables];
}

- (IBAction)testVariablesPressed:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"[T1]"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:1], @"a", 
                                   [NSNumber numberWithInt:2], @"b",
                                   nil];
    } else if ([sender.currentTitle isEqualToString:@"[T2]"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:-1], @"a", 
                                   [NSNumber numberWithInt:-2], @"b",
                                   nil];
    } else if ([sender.currentTitle isEqualToString:@"[NIL]"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   nil, @"a", 
                                   nil, @"b",
                                   nil];
    } else if ([sender.currentTitle isEqualToString:@"[RND]"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:random_float(-10, 10)], @"a", 
                                   [NSNumber numberWithFloat:random_float(-10, 10)], @"b",
                                   nil];
    }
    [self runProgram];
}

- (void)updateDisplay:(NSString *)text
{
    [self updateDisplay:text shouldAppend:NO];
}

- (void)updateDisplay:(NSString *)text shouldAppend:(BOOL)shouldAppend
{
    if (shouldAppend)
        self.display.text = [self.display.text stringByAppendingString:text];
    else
        self.display.text = text;
}

- (void)updateHistory
{
    self.history.text = [CalculatorAlgorithmRPN descriptionOfProgram:self.brain.program];
}

- (void)updateVariables
{
    NSString *text = @"";
    
    for (NSString *var in [CalculatorAlgorithmRPN variablesUsedInProgram:self.brain.program]) {
        text = [text stringByAppendingFormat:@" %@ = %@ ", var, [self.testVariableValues objectForKey:var]];
    }
    
    self.variables.text = text;
}

- (void)runProgram
{
    id result = [CalculatorAlgorithmRPN runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    
    if ([result isKindOfClass:[NSNumber class]]) {
        [self updateDisplay:[NSString stringWithFormat:@"%@", result]];
        [self updateHistory];
        [self updateVariables];
        
    } else if ([result isKindOfClass:[NSString class]]) {
        [self.brain clearTopOfStack];
        self.history.text = result;
    }
}

- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setHistory:nil];
    [self setVariables:nil];
    [super viewDidUnload];
}

@end
