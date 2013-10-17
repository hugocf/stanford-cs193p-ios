/**
 Since Objective-C does not have real abstract classes, a common idiom is to raise an exception
 form the abstract class in case the subclass forgets to override/implement the method.
 
 Default behaviour in Cocoa (e.g. NSFormatter):
 
     *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 
    '*** -stringForObjectValue: only defined for abstract class.  Define -[MyFormatter stringForObjectValue:]!'
 
 References and inspiration:
 - https://github.com/stevegeek/cocotron/blob/master/Foundation/NSException/NSRaise.h
 - http://xcodeit.net/blog/abstract-classes-and-objective-c.html
 - http://stackoverflow.com/questions/1034373/creating-an-abstract-class-in-objective-c
 - https://developer.apple.com/library/ios/qa/qa1669/
 */

/*
    *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 
    '-instanceMethod only defined for abstract class. Define -[MySubclass instanceMethod]! (in MDKExceptionsTest.m:76)'
or,
    '+classMethod only defined for abstract class. Define +[MySubclass classMethod]! (in MDKExceptionsTest.m:44)'
*/
static inline void MDKInvalidAbstractInvocation(SEL selector, id object, const char *func, const char *file, int line) {
    char sign = func[0];
    const char *method = sel_getName(selector);
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    NSString *message = [NSString stringWithFormat:@"%c%s only defined for abstract class. Define %c[%@ %s]! (in %@:%d)",
                                                   sign, method, sign, [object class], method, fileName, line];
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:message userInfo:nil];
}
#define RaiseInvalidAbstractInvocation() MDKInvalidAbstractInvocation(_cmd, self, __func__, __FILE__, __LINE__)

/*
    *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 
    '-[MyAbstract init] cannot instantiate abstract class directly. Use a subclass instead! (in MDKExceptionsTest.m:25)'
*/
static inline void MDKInvalidAbstractInstantiationForClass(Class abstract, id object, const char *func, const char *file, int line) {
    if ([object class] == abstract) {
        NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
        NSString *message = [NSString stringWithFormat:@"%s cannot instantiate abstract class directly. Use a subclass instead! (in %@:%d)",
                                                       func, fileName, line];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:message userInfo:nil];
    }
}
#define RaiseInvalidAbstractInstantiationForClass(CLASS) MDKInvalidAbstractInstantiationForClass(CLASS, self, __func__, __FILE__, __LINE__)
