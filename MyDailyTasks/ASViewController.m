//
//  ASViewController.m
//  MyDailyTasks
//
//  Created by Ade on 1/5/14.
//  Copyright (c) 2014 Ade. All rights reserved.
//

#import "ASViewController.h"
#import "ASAppDelegate.h"
#import "ASTaskCell.h"
#import "Masonry.h"

@interface ASViewController ()

@end

@implementation ASViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

- (void) viewWillAppear:(BOOL)animated
{
    ASAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSArray *myTasks = delegate.tasks;
    
    if ([myTasks count] == 0)
    {
        [self.mainView bringSubviewToFront:self.noItemsView];
    }
    else if ([myTasks count] > 0)   /*If there are actually task, then we show these tasks*/
    {
        [self.tableView reloadData];
        [self.mainView bringSubviewToFront:self.tableView];
    }
}

- (void)viewDidLoad
{
    //First add the view that will display that the user has entered nothing.
    self.noItemsView = [[[NSBundle mainBundle] loadNibNamed:@"NoTasksView" owner:self options:nil] objectAtIndex:0];
    [self.mainView addSubview:self.noItemsView];
    
    //Then we enter the view that displays whatever tasks you have saved.
    self.tableView = [[[NSBundle mainBundle] loadNibNamed:@"TasksList" owner:self options:nil] objectAtIndex:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.mainView addSubview:self.tableView];
    
    
    [self.noItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.noItemsView.superview);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView.superview);
    }];
    
    [super viewDidLoad];
    
    //Set the border information for the add button.
    self.addButton.layer.borderWidth = 2.0;
    self.addButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.addButton.layer.cornerRadius = self.addButton.frame.size.width / 2.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASTaskCell *cell = [[ASTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        [self saveContext:context];
    }
}

- (void) saveContext : (NSManagedObjectContext *) context
{
    NSError *error = nil;

    if (![context save:&error]) {
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Deleting" message:@"There was a problem deleting the calculation.  It wasn't your fault.  Restart the application, and try again please.  If the problem persists, please email mydailytasksapp@gmail.com and explain the problem." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            
            [alert show];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    //    self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     //   [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSSortDescriptor *completedSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"completed" ascending:YES];
    NSArray *sortDescriptors = @[completedSortDescriptor, dateSortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Tasks" message:@"There was a problem loading all the tasks.  It wasn't your fault.  Restart the application, and try again please.  If the problem persists, please email mydailytasksapp@gmail.com and explain the problem." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
        
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
        {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            ASAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            
            delegate.tasks = [self.fetchedResultsController fetchedObjects];
            if ([delegate.tasks count] == 0)
            {
                UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"NoTasksView" owner:self options:nil] objectAtIndex:0];
                
                [self.mainView addSubview:view];
            }
            break;
        }
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIButton *button = ((ASTaskCell *) cell).doneButton;
    
    NSDate *date = [object valueForKey:@"date"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //Get the day from the date stored within this managed object.
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    date = [calendar dateFromComponents:components];
    
    NSDate *today = [NSDate date];
    //Get the day from today's date.
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    today = [calendar dateFromComponents:todayComponents];
    
    //Check to see if this task has been completed or not.
    if ([[object valueForKey:@"completed"] isEqualToNumber:[NSNumber numberWithBool:YES]])
    {
        //Change the appearance of the done button to show a finished task.
        [button setImage:[UIImage imageNamed:@"finished.png"] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        button.layer.backgroundColor = [UIColor clearColor].CGColor;
    
        if ([date compare:today] == NSOrderedAscending)
        {
            NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
            [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
            [self saveContext:context];
        }
    }
    else
    {
        if ([date compare:today] == NSOrderedAscending)
        {
            ((ASTaskCell *) cell).lblTask.textColor = [UIColor redColor];
        }
    }
    
    ((ASTaskCell *) cell).lblTask.text  = [NSString stringWithFormat:@"%@", [[object valueForKey:@"task"] description ]];
    //Get the UUID of the task and store it in the cell object.
    ((ASTaskCell *) cell).uuid = [[object valueForKey:@"id"] description];
}

@end
