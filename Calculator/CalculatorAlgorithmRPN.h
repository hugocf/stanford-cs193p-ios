//
//  CalculatorAlgorithmRPN.h
//  Calculator
//
//  Created by Hugo Ferreira on 2012/07/05.
//  Copyright (c) 2012 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorAlgorithmRPN : NSObject

- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)variable;
- (void)pushOperation:(NSString *)operation;
- (void)clearStack;
- (void)clearTopOfStack;

@property (readonly) id program;

+ (id)runProgram:(id)program;
+ (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (BOOL)isVariable:(NSString *)element;

@end
