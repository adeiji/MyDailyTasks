//
//  ASTaskManagedObject.m
//  MyDailyTasks
//
//  Created by Ade on 1/12/14.
//  Copyright (c) 2014 Ade. All rights reserved.
//

#import "ASTaskManagedObject.h"
#import "ASAppDelegate.h"

@implementation ASTaskManagedObject

- (void) didSave
{
    ASAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController.navigationController popViewControllerAnimated:YES];
}

@end
