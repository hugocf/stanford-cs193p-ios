//
//  GameResult.h
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/10.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults; // of GameResult

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval  duration;
@property (nonatomic) int score;
@property (nonatomic) NSString *gameName;

- (NSComparisonResult)compareDateDescending:(GameResult *)otherResult;
- (NSComparisonResult)compareDurationAscending:(GameResult *)otherResult;
- (NSComparisonResult)compareScoreDescending:(GameResult *)otherResult;

@end
