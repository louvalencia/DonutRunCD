//
//  Donut.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/25/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order, Person;

@interface Donut : NSManagedObject

@property (nonatomic, retain) NSString * flavor;
@property (nonatomic, retain) NSNumber * qty;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) Order *inOrder;
@property (nonatomic, retain) Person *owner;

@end
