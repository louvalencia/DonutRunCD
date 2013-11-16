//
//  EditOrderTableViewController.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/10/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderBuilderCell.h"
#import "EditOrderHeader.h"
#import "AddPeopleToOrderTableViewController.h"
#import "PeopleTableViewController.h"

@protocol EditOrderTableViewControllerDelegate;

@interface EditOrderTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddPeopleToOrderTableViewControllerDelegate, EditOrderHeaderDelegate, PeopleTableViewControllerDelegate>

@property (nonatomic, strong) id <EditOrderTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@protocol EditOrderTableViewControllerDelegate
- (void)didFinishWithEditOrderTableViewController:(EditOrderTableViewController *)controller;
@end