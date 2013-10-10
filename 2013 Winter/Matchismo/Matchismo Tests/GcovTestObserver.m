//
//  GcovTestObserver.m
//  http://stackoverflow.com/questions/19136767/generate-gcda-files-with-xcode5-ios7-simulator-and-xctest
//

#import <XCTest/XCTestLog.h>
#import <XCTest/XCTestSuiteRun.h>
#import <XCTest/XCTest.h>

// Workaround for XCode 5 bug where __gcov_flush is not called properly when Test Coverage flags are set

@interface GcovTestObserver : XCTestLog
@end

#ifdef DEBUG
extern void __gcov_flush(void);
#endif

static NSUInteger sTestCounter = 0;
static id mainSuite = nil;

@implementation GcovTestObserver

+ (void)initialize {
    [[NSUserDefaults standardUserDefaults] setValue:@"GcovTestObserver"
                                             forKey:XCTestObserverClassKey];
    [super initialize];
}

- (void)testSuiteDidStart:(XCTestRun *)testRun {
    [super testSuiteDidStart:testRun];
    
    XCTestSuiteRun *suite = [[XCTestSuiteRun alloc] init];
    [suite addTestRun:testRun];
    
    sTestCounter++;
    
    if (mainSuite == nil) {
        mainSuite = suite;
    }
}

- (void)testSuiteDidStop:(XCTestRun *)testRun {
    
    sTestCounter--;
    
    [super testSuiteDidStop:testRun];
    
    XCTestSuiteRun *suite = [[XCTestSuiteRun alloc] init];
    [suite addTestRun:testRun];
    
    if (sTestCounter == 0) {
        __gcov_flush();
    }
}

@end
