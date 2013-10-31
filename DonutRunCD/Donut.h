//
//  Donut.h
//  DonutRunCD
//
//  Created by Lou Valencia on 10/30/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Donut : NSManagedObject

@property (nonatomic, retain) NSString * flavor;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * qty;
@property (nonatomic, retain) Person *owner;

@end
