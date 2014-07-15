//
//  ASAddTaskViewController.h
//  MyDailyTasks
//
//  Created by Ade on 1/5/14.
//  Copyright (c) 2014 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASAddTaskViewController : UIViewController <UITextViewDelegate>

#pragma mark - Outlets

@property (strong, nonatomic) IBOutlet UIView *barView;
@property (strong, nonatomic) IBOutlet UITextView *mainTextView;
@property (strong, nonatomic) IBOutlet UIButton *cancelOkButton;
@property (strong, nonatomic) IBOutlet UILabel *lblMaxCharactersLeft;

#pragma mark - Actions
- (IBAction)cancelOkPressed:(id)sender;
- (IBAction)addTaskPressed:(id)sender;

@end
