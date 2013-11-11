//
//  EditOrderTableViewController.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/10/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderBuilderCell.h"
#import "AddPeopleToOrderTableViewController.h"

@protocol EditOrderTableViewControllerDelegate;

@interface EditOrderTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddPeopleToOrderTableViewControllerDelegate>

@property (nonatomic, strong) id <EditOrderTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@protocol EditOrderTableViewControllerDelegate
- (void)didFinishWithEditOrderTableViewController:(EditOrderTableViewController *)controller;
@end