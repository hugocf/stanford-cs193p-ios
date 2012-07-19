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

- (void)pushOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
}

- (void)clearStack
{
    [self.programStack removeAllObjects];
}

- (void)clearTopOfStack
{
    [self.programStack removeLastObject];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSDictionary *)operations
{
    if (!_operations) {
        NSMutableDictionary *ops = [[NSMutableDictionary alloc] init];
        
        NSNumber *two = [NSNumber numberWithUnsignedInt:2];        
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:two, MY_OPERANDS_COUNT, @"(%@ ÷ %@)", MY_FORMAT_STRING, nil] forKey:@"/"];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:two, MY_OPERANDS_COUNT, @"(%@ × %@)", MY_FORMAT_STRING, nil] forKey:@"*"];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:two, MY_OPERANDS_COUNT, @"(%@ − %@)", MY_FORMAT_STRING, nil] forKey:@"-"];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:two, MY_OPERANDS_COUNT, @"(%@ + %@)", MY_FORMAT_STRING, nil] forKey:@"+"];
        
        NSNumber *one = [NSNumber numberWithUnsignedInt:1];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:one, MY_OPERANDS_COUNT, @"sin(%@)", MY_FORMAT_STRING, nil] forKey:@"sin"];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:one, MY_OPERANDS_COUNT, @"cos(%@)", MY_FORMAT_STRING, nil] forKey:@"cos"];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:one, MY_OPERANDS_COUNT, @"√(%@)",   MY_FORMAT_STRING, nil] forKey:@"√"];
        
        NSNumber *nop = [NSNumber numberWithUnsignedInt:0];
        [ops setValue:[NSDictionary dictionaryWithObjectsAndKeys:nop, MY_OPERANDS_COUNT, @"π", MY_FORMAT_STRING, nil] forKey:@"π"];
        
        _operations = [ops copy];
    }
    
    return _operations;
}

+ (id)runProgram:(id)program
{
    return [self runProgram:program usingVariableValues:nil];
}

+ (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    // Check each element of the program
    for (NSUInteger idx = 0; idx < [stack count]; idx++) {
        id element = [stack objectAtIndex:idx];
        
        if ([self isVariable:element]) {
            // Replace with the variable's value
            id value = [variableValues objectForKey:element];
            if ([value isKindOfClass:[NSNumber class]]) {
                [stack replaceObjectAtIndex:idx withObject:value];
            } else {
                [stack replaceObjectAtIndex:idx withObject:[NSNumber numberWithInt:0]];
            }
        }
    }
    
    return [self popElementFromStack:stack];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    NSString *result;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    result = [self unwrapParenthesis:[self descriptionOfTopOfStack:stack]];
    while ([stack count] != 0) {
        result = [[self unwrapParenthesis:[self descriptionOfTopOfStack:stack]] stringByAppendingFormat:@", %@", result];
    }
    
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSSet *variables;
    
    if ([program isKindOfClass:[NSArray class]]) {
        NSPredicate *variablesOnly = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [self isVariable:evaluatedObject];
        }];
        variables = [NSSet setWithArray:[program filteredArrayUsingPredicate:variablesOnly]];
    }
    
    return variables;
}

+ (BOOL)isVariable:(id)element
{
    // Variables are strings that contain a letter and are not operations
    return [element isKindOfClass:[NSString class]] 
        && ([element rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound)
        && ![[self operations] objectForKey:element];
}

+ (id)popElementFromStack:(NSMutableArray *)stack 
{
    id result;
    
    id element = [stack lastObject];
    if (element) [stack removeLastObject];
    
    if ([element isKindOfClass:[NSNumber class]]) {
        result = element;
    }
    else if ([element isKindOfClass:[NSString class]]) {
        result = [self calculateOperation:element withStack:stack];
    }
    
    return result;
}

+ (id)calculateOperation:(NSString *)operation withStack:(NSMutableArray *)stack
{
    id result, firstObject, secondObject;
    double firstValue = 0, secondValue = 0;
    unichar symbol;

    if ([operation length] > 0) symbol = [operation characterAtIndex:0];
    switch (symbol) {
        case '/':
            secondObject = [self popElementFromStack:stack];
            firstObject  = [self popElementFromStack:stack];
            if (!firstObject || !secondObject) {
                result = [@"ERR: Not enough operands for " stringByAppendingString:operation];
            } else {
                result = [self errorInOperand:firstObject or:secondObject];
                if (!result) {
                    if ([secondObject isKindOfClass:[NSNumber class]]) secondValue = [secondObject doubleValue];
                    if ([firstObject  isKindOfClass:[NSNumber class]]) firstValue  = [firstObject  doubleValue];
                    
                    if (secondValue == 0) {
                        result = @"ERR: Divide by 0";
                    } else {
                        result = [NSNumber numberWithDouble:firstValue / secondValue];
                    }
                }
            }
            break;
            
        case '*':
            secondObject = [self popElementFromStack:stack];
            firstObject  = [self popElementFromStack:stack];
            if (!firstObject || !secondObject) {
                result = [@"ERR: Not enough operands for " stringByAppendingString:operation];
            } else {
                result = [self errorInOperand:firstObject or:secondObject];
                if (!result) {
                    if ([secondObject isKindOfClass:[NSNumber class]]) secondValue = [secondObject doubleValue];
                    if ([firstObject  isKindOfClass:[NSNumber class]]) firstValue  = [firstObject  doubleValue];
                    result = [NSNumber numberWithDouble:firstValue * secondValue];
                }
            }
            break;
            
        case '-':
            secondObject = [self popElementFromStack:stack];
            firstObject  = [self popElementFromStack:stack];
            if (!firstObject || !secondObject) {
                result = [@"ERR: Not enough operands for " stringByAppendingString:operation];
            } else {
                result = [self errorInOperand:firstObject or:secondObject];
                if (!result) {
                    if ([secondObject isKindOfClass:[NSNumber class]]) secondValue = [secondObject doubleValue];
                    if ([firstObject  isKindOfClass:[NSNumber class]]) firstValue  = [firstObject  doubleValue];
                    result = [NSNumber numberWithDouble:firstValue - secondValue];
                }
            }
            break;
            
        case '+':
            secondObject = [self popElementFromStack:stack];
            firstObject  = [self popElementFromStack:stack];
            if (!firstObject || !secondObject) {
                result = [@"ERR: Not enough operands for " stringByAppendingString:operation];
            } else {
                result = [self errorInOperand:firstObject or:secondObject];
                if (!result) {
                    if ([secondObject isKindOfClass:[NSNumber class]]) secondValue = [secondObject doubleValue];
                    if ([firstObject  isKindOfClass:[NSNumber class]]) firstValue  = [firstObject  doubleValue];
                    result = [NSNumber numberWithDouble:firstValue + secondValue];
                }
            }
            break;
            
        case 's':
            firstObject  = [self popElementFromStack:stack];
            if (!firstObject) {
                result = [@"ERR: Not enough operands for " stringByAppendingString:operation];
            } else {
                result = [self errorInOperand:firstObject];
                if (!result) {
                    if ([firstObject isKindOfClass:[NSNumber class]]) firstValue = [firstObject doubleValue];
                    result = [NSNumber numberWithDouble:sin(firstValue)];
                }
            }
            break;
            
        case 'c':
            firstObject  = [self popElementFromStack:stack];
            if (!firstObject) {
                result = [@"ERR: Not enough operands for " stringByAppendingString:operation];
            } else {
                result = [self errorInOperand:firstObject];
                if (!result) {
                    if ([firstObject isKindOfClass:[NSNumber class]]) firstValue = [firstObject doubleValue];
                    result = [NSNumber numberWithDouble:cos(firstValue)];
                }
            }
            break;
            
        case 0x221A: // √
            firstObject  = [self popElementFromStack:stack];
            if (!firstObject) {
                result = [@"ERR: Not enough operands for " stringByAppendingString:operation];
            } else {
                result = [self errorInOperand:firstObject];
                if (!result) {
                    if ([firstObject isKindOfClass:[NSNumber class]]) firstValue = [firstObject doubleValue];
                    if (firstValue < 0) {
                        result = @"ERR: Negative √";
                    } else {
                        result = [NSNumber numberWithDouble:sqrt(firstValue)];
                    }
                }
            }
            break;
            
        case 0x03C0: // π
            result = [NSNumber numberWithDouble:M_PI];
            break;
            
        default:
            result = [NSString stringWithFormat:@"ERR: Unsupported operation %@", operation];
            break;
    }
    
    return result;
}

+ (NSString *)errorInOperand:(id)operand
{
    NSString *result;
    
    // If it's a string with data then it's an error
    if ([operand isKindOfClass:[NSString class]]) {
        operand = [operand stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![operand isEqualToString:@""])  {
            result = operand;
        }
    }
    
    return result;
}

+ (NSString *)errorInOperand:(id)first or:(id)second
{
    NSString *result;
    NSString *firstError  = [self errorInOperand:first];
    NSString *secondError = [self errorInOperand:second];
    
    if (firstError || secondError) {
        result = [[NSArray arrayWithObjects:firstError, secondError, nil] componentsJoinedByString:@" "];
    }
    
    return result;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *result = @"";
    NSUInteger operands;
    NSString *format, *first, *second;
    
    id element = [stack lastObject];
    if (element) {
        [stack removeLastObject];
        
        NSDictionary *operation = [[self operations] objectForKey:element]; 
        if (operation) {
            // If the element is an operation...
            operands = [[operation objectForKey:MY_OPERANDS_COUNT] unsignedIntegerValue];
            format = [operation objectForKey:MY_FORMAT_STRING];
            switch (operands) {
                case 2:
                    second = [self descriptionOfTopOfStack:stack];
                    first  = [self descriptionOfTopOfStack:stack];
                    if ([second isEqualToString:@""]) second = @"0";
                    if ([first isEqualToString:@""]) first = @"0";
                    result = [NSString stringWithFormat:format, first, second];
                    break;
                    
                case 1:
                    first  = [self descriptionOfTopOfStack:stack];
                    if ([first isEqualToString:@""]) first = @"0";
                    result = [NSString stringWithFormat:format, [self unwrapParenthesis:first]];
                    break;
                    
                case 0:
                    result = format;
                    break;
                    
                default:
                    NSLog(@"ERR: Unsupported number of operands for operation %@: %@", operation, operands);
                    break;
            }
        } else {
            // If it is a regular element...
            result = [element description];
        }
    }
    
    return result;
}

+ (NSString *)unwrapParenthesis:(NSString *)text
{
    NSString *result = text;
    
    if ([text hasPrefix:@"("] && [text hasSuffix:@")"]) {
        result = [text substringWithRange:NSMakeRange(1, [text length]-2)];
    }
    
    return result;
}

@end

