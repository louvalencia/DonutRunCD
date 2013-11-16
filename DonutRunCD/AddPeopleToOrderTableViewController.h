//
//  AddPeopleToOrderTableViewController.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/11/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@protocol AddPeopleToOrderTableViewControllerDelegate;

@interface AddPeopleToOrderTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id <AddPeopleToOrderTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@protocol AddPeopleToOrderTableViewControllerDelegate
- (void)didFinishWithAddPeopleToOrderTableViewController:(AddPeopleToOrderTableViewController *)controller;
@end
