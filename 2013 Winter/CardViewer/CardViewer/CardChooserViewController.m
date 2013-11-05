//
//  CardChooserViewController.m
//  CardViewer
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardChooserViewController.h"
#import "CardDisplayViewController.h"

@interface CardChooserViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *suitSegmentedControl;
@property (nonatomic) NSUInteger rank;
@property (nonatomic, readonly) NSString *suit;
@end

@implementation CardChooserViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowCard"]) {
        if ([segue.destinationViewController isKindOfClass:[CardDisplayViewController class]]) {
            CardDisplayViewController *cdvc = (CardDisplayViewController *)segue.destinationViewController;
            cdvc.suit = self.suit;
            cdvc.rank = self.rank;
            cdvc.title = [[self rankAsString] stringByAppendingString:self.suit];
        }
    }
}

- (NSString *)rankAsString
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

- (void)setRank:(NSUInteger)rank
{
    _rank = rank;
    self.rankLabel.text = [self rankAsString];
}

- (NSString *)suit
{
    return [self.suitSegmentedControl titleForSegmentAtIndex:self.suitSegmentedControl.selectedSegmentIndex];
}

- (IBAction)changeRank:(UISlider *)sender
{
    self.rank = round(sender.value);
}

@end
