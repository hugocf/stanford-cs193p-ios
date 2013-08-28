//
//  AttributeViewController.m
//  Attribute
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "AttributeViewController.h"

@interface AttributeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIStepper *selectedWordStepper;
@property (weak, nonatomic) IBOutlet UILabel *selectedWordLabel;
@end

@implementation AttributeViewController

// returns a list of the words in self.label
- (NSArray *)wordList
{
    NSArray *wordList = [[self.label.attributedText string] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([wordList count]) {
        return wordList;
    } else {
        return @[@""]; // never return empty list (makes code simpler elsewhere)
    }
}

// returns the word from the wordList chosen by the stepper
- (NSString *)selectedWord
{
    return [self wordList][(int)self.selectedWordStepper.value];
}

// keeps stepper in line
// updates the selected word label to show the selected word
- (IBAction)updateSelectedWord
{
    self.selectedWordStepper.maximumValue = [[self wordList] count]-1;
    self.selectedWordLabel.text = [self selectedWord];
    
    // added after lecture
    [self addLabelAttributes:@{ NSBackgroundColorAttributeName : [UIColor whiteColor] }
                       range:NSMakeRange(0, [self.label.attributedText length])];
    [self addSelectedWordAttributes:@{ NSBackgroundColorAttributeName : [UIColor yellowColor] }];
}

#pragma mark - View Controller Lifecycle

// called after all outlets have been set up
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateSelectedWord];
}

#pragma mark - Changing Attributes

// add attributes to the given range in self.label
- (void)addLabelAttributes:(NSDictionary *)attributes range:(NSRange)range
{
    if (range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.label.attributedText mutableCopy];
        [mat addAttributes:attributes
                     range:range];
        self.label.attributedText = mat;
    }
}

// add attributes to the selected word in self.label
- (void)addSelectedWordAttributes:(NSDictionary *)attributes
{
    NSRange range = [[self.label.attributedText string] rangeOfString:[self selectedWord]];
    [self addLabelAttributes:attributes range:range];
}

- (IBAction)underline
{
    [self addSelectedWordAttributes:@{ NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
}

- (IBAction)ununderline
{
    [self addSelectedWordAttributes:@{ NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}];
}

- (IBAction)changeColor:(UIButton *)sender
{
    [self addSelectedWordAttributes:@{ NSForegroundColorAttributeName : sender.backgroundColor }];
}

- (IBAction)changeFont:(UIButton *)sender
{
    CGFloat fontSize = [UIFont systemFontSize];

    // next two lines added after lecture
    NSRange range = [[self.label.attributedText string] rangeOfString:[self selectedWord]];
    if (range.location != NSNotFound) {
        NSDictionary *attributes = [self.label.attributedText attributesAtIndex:range.location // was 0 in lecture
                                                                 effectiveRange:NULL];
        UIFont *existingFont = attributes[NSFontAttributeName];
        if (existingFont) fontSize = existingFont.pointSize;
    }

    UIFont *font = [sender.titleLabel.font fontWithSize:fontSize];
    [self addSelectedWordAttributes:@{ NSFontAttributeName : font }];
}

// added after lecture
- (IBAction)outline
{
    [self addSelectedWordAttributes:@{ NSStrokeWidthAttributeName : @5 }]; // stroke only, no fill
}

// added after lecture
- (IBAction)unoutline
{
    [self addSelectedWordAttributes:@{ NSStrokeWidthAttributeName : @0 }];
}

// added after lecture
// not currently hooked up to the UI
// hook it up to see what it does!
- (IBAction)outlineAndFill
{
    [self addSelectedWordAttributes:@{ NSStrokeWidthAttributeName : @-5,  // stroke and fill
                                       NSStrokeColorAttributeName : [UIColor blackColor] }];
}

@end
