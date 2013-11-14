//
//  FlickrFetcherLearningTests.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/12.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FlickrFetcher.h"

@interface FlickrFetcherLearningTests : XCTestCase

@end

@implementation FlickrFetcherLearningTests

- (void)testStanfordPhotosReturnsTags
{
    NSArray *photos = [FlickrFetcher stanfordPhotos];
    NSArray *tagsPerPhoto = [photos valueForKey:FLICKR_TAGS];
    NSArray *allTagsUsed = [[tagsPerPhoto componentsJoinedByString:@" "] componentsSeparatedByString:@" "];
    NSSet *uniqueTagList = [NSSet setWithArray:allTagsUsed];
    XCTAssert([uniqueTagList count] < [allTagsUsed count], @"Duplicate tags should have disappeared");
}

- (void)testRecentPhotosReturnsLimitedSize
{
    NSArray *photos = [FlickrFetcher latestGeoreferencedPhotos];
    XCTAssertEqual([photos count] <= 250, @"Too many photos received");
}

@end
