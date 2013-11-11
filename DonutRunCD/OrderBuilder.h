//
//  OrderBuilder.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/11/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface OrderBuilder : NSManagedObject

@property (nonatomic, retain) NSNumber * qty;
@property (nonatomic, retain) Person *person;

@end
