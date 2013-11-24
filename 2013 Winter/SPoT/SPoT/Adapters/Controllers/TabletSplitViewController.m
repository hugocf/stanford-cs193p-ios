//
//  TabletSplitViewController.m
//  SPoT
//
//  Created by Hugo Ferreira on 2013/11/24.
//  Copyright (c) 2013 Mindclick. All rights reserved.
//

#import "TabletSplitViewController.h"

@interface TabletSplitViewController () <UISplitViewControllerDelegate>

@end

@implementation TabletSplitViewController

#pragma mark - NSObject

- (void)awakeFromNib
{
    self.delegate = self;
}

#pragma mark - UISplitViewControllerDelegate

-(BOOL)splitViewController:(UISplitViewController *)svc
  shouldHideViewController:(UIViewController *)vc
             inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

@end
