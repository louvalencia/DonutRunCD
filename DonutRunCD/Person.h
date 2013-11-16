//
//  Person.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/14/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Donut;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * inOrder;
@property (nonatomic, retain) NSNumber * qtyInOrder;
@property (nonatomic, retain) NSSet *favorites;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addFavoritesObject:(Donut *)value;
- (void)removeFavoritesObject:(Donut *)value;
- (void)addFavorites:(NSSet *)values;
- (void)removeFavorites:(NSSet *)values;

@end