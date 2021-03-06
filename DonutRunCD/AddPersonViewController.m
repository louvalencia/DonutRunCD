//
//  AddPersonViewController.m
//  DonutRunCD
//
//  Created by Lou Valencia on 10/31/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import "AddPersonViewController.h"
#import "Person.h"

@interface AddPersonViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameField;

@end

@implementation AddPersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.nameField becomeFirstResponder];
    [self.nameField addTarget:self action:@selector(save:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self.delegate addPersonViewController:self didFinishWithSave:NO];
}


- (IBAction)save:(id)sender
{
    self.person.name = self.nameField.text;
    self.person.inOrder = [NSNumber numberWithBool:NO];
    self.person.qtyInOrder = [NSNumber numberWithInt:1];
    [self.delegate addPersonViewController:self didFinishWithSave:YES];
}

@end
