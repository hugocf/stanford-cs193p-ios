//
//  GcovTestObserver.m
//
//  Workaround for XCode 5 bug where __gcov_flush is not called properly when test coverage flags are set.
//  http://stackoverflow.com/questions/19136767/generate-gcda-files-with-xcode5-ios7-simulator-and-xctest
//

#import <XCTest/XCTestObserver.h>

@interface GcovTestObserver : XCTestObserver
@end

@implementation GcovTestObserver

- (void) stopObserving
{
    [super stopObserving];
    UIApplication* application = [UIApplication sharedApplication];
    [application.delegate applicationWillTerminate:application];
}

@end
