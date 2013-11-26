//
//  Order.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/25/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Donut;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSNumber * qty;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSSet *donutItems;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addDonutItemsObject:(Donut *)value;
- (void)removeDonutItemsObject:(Donut *)value;
- (void)addDonutItems:(NSSet *)values;
- (void)removeDonutItems:(NSSet *)values;

@end
