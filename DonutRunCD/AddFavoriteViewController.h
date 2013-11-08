//
//  AddFavoriteViewController.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/7/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Donut;
@class Person;

@protocol AddFavoriteViewControllerDelegate;

@interface AddFavoriteViewController : UIViewController

@property (nonatomic, weak) id <AddFavoriteViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Donut *donut;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSNumber *rank;

@end

@protocol AddFavoriteViewControllerDelegate
- (void)addFavoriteViewController:(AddFavoriteViewController *)controller didFinishWithSave:(BOOL)save;
@end
