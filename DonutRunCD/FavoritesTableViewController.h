//
//  FavoritesTableViewController.h
//  DonutRunCD
//
//  Created by Lou Valencia on 10/30/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;
@class Donut;

@interface FavoritesTableViewController : UITableViewController
    <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) Donut *donut;

@end
