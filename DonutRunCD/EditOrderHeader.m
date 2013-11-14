//
//  EditOrderHeader.m
//  DonutRunCD
//
//  Created by Lou Valencia on 11/10/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import "EditOrderHeader.h"

@interface EditOrderHeader ()

@property (weak, nonatomic) IBOutlet UITextField *qtyTextField;
@property (weak, nonatomic) IBOutlet UIStepper *dozenStepper;
@property (weak, nonatomic) IBOutlet UIStepper *donutStepper;

- (IBAction)dozenStepped:(UIStepper *)sender;
- (IBAction)donutStepped:(UIStepper *)sender;
- (IBAction)distribute:(UIButton *)sender;


@end

@implementation EditOrderHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [self.qtyTextField addTarget:self action:@selector(doneTapped:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)doneTapped:(id) sender
{
    // [self.qtyTextField resignFirstResponder];
    [self.qtyTextField endEditing:YES];
}

- (IBAction)dozenStepped:(UIStepper *)sender
{
    
}

- (IBAction)donutStepped:(UIStepper *)sender
{
    
}

- (IBAction)distribute:(UIButton *)sender
{
    
}
@end
