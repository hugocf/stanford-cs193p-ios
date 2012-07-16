//
//  CalculatorAlgorithmRPN.m
//  Calculator
//
//  Created by Hugo Ferreira on 2012/07/05.
//  Copyright (c) 2012 Mindclick. All rights reserved.
//

#import "CalculatorAlgorithmRPN.h"

@interface CalculatorAlgorithmRPN ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorAlgorithmRPN

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}
 
- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorAlgorithmRPN runProgram:self.program];
}

- (id)program {
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program {
    return @"TODO: HF";
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self popElementFromStack:stack];
}

+ (double)popElementFromStack:(NSMutableArray *)stack {
    double result = 0;
    
    id element = [stack lastObject];
    if (element) [stack removeLastObject];
    
    if ([element isKindOfClass:[NSNumber class]]) {
        result = [element doubleValue];
    }
    else if ([element isKindOfClass:[NSString class]]) {
        result = [self calculateOperation:element withStack:stack];
    }
    
    return result;
}

+ (double)calculateOperation:(NSString *)operation withStack:(NSMutableArray *)stack {
    double result = 0;
    double first, second;
    unichar symbol;
    
    if ([operation length] > 0) {
        symbol = [operation characterAtIndex:0];
    }
    switch (symbol) {
        case '/':
            second = [self popElementFromStack:stack];
            first  = [self popElementFromStack:stack];
            if (second) result = first / second;
            break;
        
        case '*':
            second = [self popElementFromStack:stack];
            first  = [self popElementFromStack:stack];
            result = first * second;
            break;
        
        case '-':
            second = [self popElementFromStack:stack];
            first  = [self popElementFromStack:stack];
            result = first - second;
            break;
        
        case '+':
            second = [self popElementFromStack:stack];
            first  = [self popElementFromStack:stack];
            result = first + second;
            break;
        
        case 's':
            result = sin([self popElementFromStack:stack]);
            break;
        
        case 'c':
            result = cos([self popElementFromStack:stack]);
            break;
        
        case 0x221A: // √
            first = [self popElementFromStack:stack];
            if (first >= 0) result = sqrt(first);
            break;
        
        case 0x03C0: // π
            result = M_PI;
            break; 
        
        default:
            // Ignore invalid operations!
            NSLog(@"Unkown operation received: %@", operation);
            break;
    }
    
    return result;
}

- (void)clearStack {
    [self.programStack  removeAllObjects];
}

@end
