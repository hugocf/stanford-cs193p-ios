//
//  PlayResult.h
//  Matchismo
//
//  Created by Hugo Ferreira on 2013/09/24.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PlayStatus) {
    PlayStatusCardFlipped,
    PlayStatusCardsMatch,
    PlayStatusCardsMismatch,
};

@interface PlayResult : NSObject

///--------------------------------------------------------------------------------
/// @name Initializing a Result
///--------------------------------------------------------------------------------

/** Designated initializer. */
- (id)initWithCards:(NSArray *)cards outcome:(PlayStatus)result score:(int)point;


///--------------------------------------------------------------------------------
/// @name Retrieving Result Information
///--------------------------------------------------------------------------------

@property (nonatomic, strong, readonly) NSArray *cards; // of Card
@property (nonatomic, readonly) PlayStatus outcome;
@property (nonatomic, readonly) NSInteger score;

- (NSString *)description;

- (NSString *)outcomeString;

@end
