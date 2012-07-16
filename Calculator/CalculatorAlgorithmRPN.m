//
//  CalculatorAlgorithmRPN.m
//  Calculator
//
//  Created by Hugo Ferreira on 2012/07/05.
//  Copyright (c) 2012 Mindclick. All rights reserved.
//

#import "CalculatorAlgorithmRPN.h"

@interface CalculatorAlgorithmRPN ()

@property (nonatomic, strong) NSMutableArray *operandStack;

@end

@implementation CalculatorAlgorithmRPN

@synthesize operandStack = _operandStack;


- (NSMutableArray *)operandStack {
    if (!_operandStack) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}
 
- (void)pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand {
    NSNumber *theOperand = [self.operandStack lastObject];
    if (theOperand) [self.operandStack removeLastObject];
    return [theOperand doubleValue];
}

- (double)performOperation:(NSString *)operation {
    double result, first, second;
    unichar symbol;
    
    if ([operation length] > 0) symbol = [operation characterAtIndex:0];
    
    switch (symbol) {
        case '/':
            second = [self popOperand];
            first  = [self popOperand];
            result = first / second;
            break;
        case '*':
            second = [self popOperand];
            first  = [self popOperand];
            result = first * second;
            break;
        case '-':
            second = [self popOperand];
            first  = [self popOperand];
            result = first - second;
            break;
        case '+':
            second = [self popOperand];
            first  = [self popOperand];
            result = first + second;
            break;
        case 's':
            result = sin([self popOperand]);
            break;
        case 'c':
            result = cos([self popOperand]);
            break;
        case 0x221A: // √
            result = sqrt([self popOperand]);
            break;
        case 0x03C0: // π
            result = M_PI;
            break;
            
        default:
            // Ignore invalid operations!
            NSLog(@"Unkown operation received: %@", operation);
            break;
    }
    [self pushOperand:result];
    
    return result;
}

- (void)clearStack {
    [self.operandStack removeAllObjects];
}

@end
