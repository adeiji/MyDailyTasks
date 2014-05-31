//
//  ASTaskCell.m
//  MyDailyTasks
//
//  Created by Ade on 1/5/14.
//  Copyright (c) 2014 Ade. All rights reserved.
//

#import "ASTaskCell.h"
#import "ASAppDelegate.h"
#import <CoreData/CoreData.h>

@implementation ASTaskCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TaskTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)donePressed:(id)sender {
    
    NSError *error;
    UIButton *button = (UIButton *) sender;
    
    //Set the Task Cell appearance to show that this task was finished.
    [button setImage:[UIImage imageNamed:@"finished.png"] forState:UIControlStateNormal];

    [button setTitle:@"" forState:UIControlStateNormal];
    button.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    //Get the global delegate so that we can access the managedObjectContext.
    ASAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    ASTaskCell *cell = (ASTaskCell*) button.superview.superview.superview ;
    
    //Fetch the record where the Task == ASTaskCell label
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Tasks"];
    [fetch setPropertiesToFetch:[NSArray arrayWithObject:@"id"]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", cell.uuid];
    [fetch setPredicate:predicate];
    
    NSArray *objects = [delegate.managedObjectContext executeFetchRequest:fetch error:&error];
    
    NSManagedObject *task = [objects objectAtIndex:0];
    
    [task setValue:[NSNumber numberWithBool:YES] forKey:@"completed"];
    
    [self performSelectorOnMainThread:@selector(saveContext:) withObject:delegate waitUntilDone:YES];
}

- (void) saveContext : (ASAppDelegate *) delegate
{
    NSError *error = nil;
    
    if (![delegate.managedObjectContext save:&error])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving" message:@"There was an error saving the task as finished.  It's not your fault.  Close the app and then try again.  If the problem continues, email mydailytasks@gmail.com, and write a detailed message about the error." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
    }
    
}

@end
