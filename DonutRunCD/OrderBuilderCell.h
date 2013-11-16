//
//  OrderBuilderCell.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/10/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderBuilderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *personLabel;
@property (nonatomic, weak) IBOutlet UILabel *donutsLabel;
@property (nonatomic, weak) IBOutlet UILabel *qtyLabel;
@property (nonatomic, weak) IBOutlet UIStepper *stepper;

@end
