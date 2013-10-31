//
//  PeopleTableViewController.h
//  DonutRunCD
//
//  Created by Lou Valencia on 10/30/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPersonViewController.h"

@interface PeopleTableViewController : UITableViewController
    <NSFetchedResultsControllerDelegate, AddPersonViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
