//
//  ASTaskManagedObject.h
//  MyDailyTasks
//
//  Created by Ade on 1/12/14.
//  Copyright (c) 2014 Ade. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ASTaskManagedObject : NSManagedObject

- (void) didSave;

@end
