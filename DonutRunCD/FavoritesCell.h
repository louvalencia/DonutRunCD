//
//  FavoritesCell.h
//  DonutRunCD
//
//  Created by Lou Valencia on 10/30/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *flavorLabel;
@property (nonatomic, weak) IBOutlet UILabel *qtyLabel;
@property (nonatomic, weak) IBOutlet UIStepper *stepper;

@end
