//
//  Order.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/10/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Donut;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * qty;
@property (nonatomic, retain) Donut *donutItem;

@end
