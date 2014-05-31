//
//  ASViewController.h
//  MyDailyTasks
//
//  Created by Ade on 1/5/14.
//  Copyright (c) 2014 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
<<<<<<< HEAD
#import <CoreData/CoreData.h>

@interface ASViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

#pragma mark - Outlets

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *navigationBarView;

#pragma mark - Core Data Objects

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
=======

@interface ASViewController : UIViewController
>>>>>>> 96b7be53482381fdf3c169113ef6049e4b1d77a6

@end
