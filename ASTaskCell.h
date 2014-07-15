//
//  ASTaskCell.h
//  MyDailyTasks
//
//  Created by Ade on 1/5/14.
//  Copyright (c) 2014 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASTaskCell : UITableViewCell

@property (strong, nonatomic) NSString *uuid;

@property (strong, nonatomic) IBOutlet UILabel *lblTask;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

#pragma mark - Button Actions

- (IBAction)donePressed:(id)sender;

@end
