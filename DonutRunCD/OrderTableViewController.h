//
//  OrderTableViewController.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/10/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCell.h"
#import "PeopleTableViewController.h"
#import "EditOrderTableViewController.h"

@class Donut;

@interface OrderTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, PeopleTableViewControllerDelegate, EditOrderTableViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Donut *donut;
@property (nonatomic, strong) NSMutableArray *order;

@end
