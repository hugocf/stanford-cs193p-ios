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

- (NSMutableArray *)programStack {
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorAlgorithmRPN runProgram:self.program];
}

- (void)clearStack {
    [self.programStack  removeAllObjects];
}

- (id)program {
    return [self.programStack copy];
}

+ (NSDictionary *)operations {
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

+ (double)runProgram:(id)program {
    return [self runProgram:program usingVariableValues:nil];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
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

+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    NSString *result;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    result = [self descriptionOfTopOfStack:stack];
    while ([stack count] != 0) {
        result = [[self descriptionOfTopOfStack:stack] stringByAppendingFormat:@", %@", result];
    }
    
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSSet *variables;
    
    if ([program isKindOfClass:[NSArray class]]) {
        NSPredicate *variablesOnly = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [self isVariable:evaluatedObject];
        }];
        variables = [NSSet setWithArray:[program filteredArrayUsingPredicate:variablesOnly]];
    }
    
    return variables;
}

+ (BOOL)isVariable:(id)element {
    // Variables are strings that contain a letter and are not operations
    return [element isKindOfClass:[NSString class]] 
        && ([element rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound) 
        && ![[self operations] objectForKey:element];
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
    
    if ([operation length] > 0) symbol = [operation characterAtIndex:0];
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
            NSLog(@"Unsupported operation received: %@", operation);
            break;
    }
    
    return result;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
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
                    result = [NSString stringWithFormat:format, first, second];
                    break;
                    
                case 1:
                    first  = [self descriptionOfTopOfStack:stack];
                    result = [NSString stringWithFormat:format, first];
                    break;
                    
                case 0:
                    result = format;
                    break;
                    
                default:
                    NSLog(@"Unsupported number of operands for operation %@: %@", operation, operands);
                    break;
            }
        } else {
            // If it is a regular element...
            result = [element description];
        }
    }
    
    return result;
}

@end

