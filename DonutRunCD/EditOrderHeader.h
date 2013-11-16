//
//  EditOrderHeader.h
//  DonutRunCD
//
//  Created by Lou Valencia on 11/10/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditOrderHeaderDelegate;

@interface EditOrderHeader : UIView

@property (weak, nonatomic) id <EditOrderHeaderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *qtyTextField;
@property (weak, nonatomic) IBOutlet UIStepper *dozenStepper;
@property (weak, nonatomic) IBOutlet UIStepper *donutStepper;

- (IBAction)dozenStepped:(UIStepper *)sender;
- (IBAction)donutStepped:(UIStepper *)sender;
- (IBAction)distribute:(UIButton *)sender;

@end

@protocol EditOrderHeaderDelegate
- (void)distributeButtonTapped;
@end