//
//  CalculatorAlgorithmRPN.m
//  Calculator
//
//  Created by Hugo Ferreira on 2012/07/05.
//  Copyright (c) 2012 Mindclick. All rights reserved.
//

#import "CalculatorAlgorithmRPN.h"
#define MY_OPERANDS_COUNT @"number of operands"
#define MY_FORMAT_STRING  @"pretty print format"

static NSDictionary *_operations;

@interface CalculatorAlgorithmRPN ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorAlgorithmRPN

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorAlgorithmRPN runProgram:self.program];
}

- (id)program
{
    return [self.programStack copy];
}

- (void)clearStack
{
    [self.programStack  removeAllObjects];
}

+ (NSDictionary *)operations
{
    if (!_operations)
    {
        NSMutableDictionary *ops = [[NSMutableDictionary alloc] init];
        
        NSNumber *two = [NSNumber numberWithInt:2];        
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:two, MY_OPERANDS_COUNT, @"%@ ÷ %@", MY_FORMAT_STRING, nil] forKey:@"/"];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:two, MY_OPERANDS_COUNT, @"%@ × %@", MY_FORMAT_STRING, nil] forKey:@"*"];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:two, MY_OPERANDS_COUNT, @"%@ − %@", MY_FORMAT_STRING, nil] forKey:@"-"];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:two, MY_OPERANDS_COUNT, @"%@ + %@", MY_FORMAT_STRING, nil] forKey:@"+"];
        
        NSNumber *one = [NSNumber numberWithInt:1];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:one, MY_OPERANDS_COUNT, @"sin(%@)", MY_FORMAT_STRING, nil] forKey:@"sin"];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:one, MY_OPERANDS_COUNT, @"cos(%@)", MY_FORMAT_STRING, nil] forKey:@"cos"];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:one, MY_OPERANDS_COUNT, @"√(%@)",   MY_FORMAT_STRING, nil] forKey:@"√"];
        
        NSNumber *nop = [NSNumber numberWithInt:0];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:nop, MY_OPERANDS_COUNT, @"π", MY_FORMAT_STRING, nil] forKey:@"π"];
        
        _operations = [ops copy];
    }
    
    return _operations;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"TODO: HF";
}

+ (double)runProgram:(id)program
{
    return [self runProgram:program usingVariableValues:nil];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }

    // Replace variables if needed
    for (NSUInteger idx = 0; idx < [stack count]; idx++)
    {
        id element = [stack objectAtIndex:idx];
        
        // Strings that are NOT operations mean it's a variable to be replaced
        if ([element isKindOfClass:[NSString class]] && ![[self operations] objectForKey:element])
        {
            id value = [variableValues objectForKey:element];
            if ([value isKindOfClass:[NSNumber class]])
                [stack replaceObjectAtIndex:idx withObject:value];
            else
                [stack replaceObjectAtIndex:idx withObject:[NSNumber numberWithInt:0]];
        }
    }
    
    return [self popElementFromStack:stack];
}

+ (double)popElementFromStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id element = [stack lastObject];
    if (element) [stack removeLastObject];
    
    if ([element isKindOfClass:[NSNumber class]])
    {
        result = [element doubleValue];
    }
    else if ([element isKindOfClass:[NSString class]])
    {
        result = [self calculateOperation:element withStack:stack];
    }
    
    return result;
}

+ (double)calculateOperation:(NSString *)operation withStack:(NSMutableArray *)stack
{
    double result = 0;
    double first, second;
    unichar symbol;
    
    if ([operation length] > 0) symbol = [operation characterAtIndex:0];
    switch (symbol)
    {
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

@end
