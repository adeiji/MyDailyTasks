//
//  ASAddTaskViewController.m
//  MyDailyTasks
//
//  Created by Ade on 1/5/14.
//  Copyright (c) 2014 Ade. All rights reserved.
//

#import "ASAddTaskViewController.h"
#import "ASAppDelegate.h"
#import <CoreData/CoreData.h>
#import "Masonry.h"
#import "ASTaskManagedObject.h"

@interface ASAddTaskViewController ()

@end

@implementation ASAddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.barView.layer.borderColor = [UIColor blackColor].CGColor;
//    self.barView.layer.borderWidth = .5f;
    
    self.cancelOkButton.layer.borderWidth = .5f;
    self.cancelOkButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.mainTextView becomeFirstResponder];
    
    self.mainTextView.delegate = self;
    

}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self performSelectorOnMainThread:@selector(addTaskPressed:) withObject:nil waitUntilDone:YES];
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    self.lblMaxCharactersLeft.text = [NSString stringWithFormat:@"%lu", 75 - newLength];
    
    return  newLength == 75 ? NO : YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Pop the ViewController of the stack
- (IBAction)cancelOkPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)addTaskPressed:(id)sender {
    
    if ([[self.mainTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0)
    {
    
        ASAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        
        NSString *task = self.mainTextView.text;
        ASTaskManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:delegate.managedObjectContext];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataSaved)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
        
        NSDateComponents *components = [[NSCalendar currentCalendar]
                                        components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                        fromDate:[NSDate date]];
        
        NSDate *date = [[NSCalendar currentCalendar]
                             dateFromComponents:components];
//        NSTimeInterval timeInterval = -60 * 60 * 24;
//        date = [date dateByAddingTimeInterval:timeInterval];
        [object setValue:task forKey:@"task"];
        [object setValue:date forKey:@"date"];
        [object setValue:[[NSUUID UUID] UUIDString] forKey:@"id"];
        
        NSError *error = nil;
        
        [self performSelectorOnMainThread:@selector(saveContext:) withObject:delegate waitUntilDone:YES];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Tasks"];
        [request setPredicate:nil];
        
        NSArray *objects = [delegate.managedObjectContext executeFetchRequest:request error:&error];
        NSDictionary *tasksDictionary = [NSDictionary dictionaryWithObjectsAndKeys:objects, @"tasks", delegate, @"delegate", nil];
        
        [self performSelectorOnMainThread:@selector(resetTasks:) withObject:tasksDictionary waitUntilDone:YES];
    }
}

- (void) dataSaved
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) saveContext : (ASAppDelegate *) delegate
{
    NSError *error;
    
    if (![delegate.managedObjectContext save:&error])
    {
        NSLog(@"Error saving data: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"Error saving the tasks.  This is not your fault.  Try going back and saving again.  If the error continues, email mydailytasksapp@gmail.com with a detail about the problem." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
    }
}

- (void) resetTasks : (NSDictionary *) dictionary
{
    NSArray *tasks = [dictionary objectForKey:@"tasks"];
    ASAppDelegate *delegate = [dictionary objectForKey:@"delegate"];
    
    delegate.tasks = tasks;
}


@end
