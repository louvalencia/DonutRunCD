//
//  Person.h
//  DonutRunCD
//
//  Created by Lou Valencia on 10/30/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Donut;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Donut *favorites;

@end
