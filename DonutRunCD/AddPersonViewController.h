//
//  AddPersonViewController.h
//  DonutRunCD
//
//  Created by Lou Valencia on 10/31/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@protocol AddPersonViewControllerDelegate;

@interface AddPersonViewController : UIViewController

@property (nonatomic, weak) id <AddPersonViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Person *person;

@end

@protocol AddPersonViewControllerDelegate
- (void)addPersonViewController:(AddPersonViewController *)controller didFinishWithSave:(BOOL)save;
@end
