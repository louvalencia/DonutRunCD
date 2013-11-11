//
//  PeopleTableViewController.h
//  DonutRunCD
//
//  Created by Lou Valencia on 10/30/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPersonViewController.h"

@protocol PeopleTableViewControllerDelegate;

@interface PeopleTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddPersonViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <PeopleTableViewControllerDelegate> delegate;

@end

@protocol PeopleTableViewControllerDelegate
- (void)didFinishWithPeopleTableViewController:(PeopleTableViewController *)controller;
@end
