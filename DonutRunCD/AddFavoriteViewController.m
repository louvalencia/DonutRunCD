//
//  AddFavoriteViewController.m
//  DonutRunCD
//
//  Created by Lou Valencia on 11/7/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import "AddFavoriteViewController.h"
#import "Donut.h"

@interface AddFavoriteViewController ()

@property (nonatomic, weak) IBOutlet UITextField *flavorField;

@end

@implementation AddFavoriteViewController

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
    [self.flavorField becomeFirstResponder];
    [self.flavorField addTarget:self action:@selector(save:)
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
    [self.delegate addFavoriteViewController:self didFinishWithSave:NO];
}


- (IBAction)save:(id)sender
{
    self.donut.flavor = self.flavorField.text;
    self.donut.qty = [NSNumber numberWithInt:1];
    self.donut.rank = self.rank;
    self.donut.owner = self.person;
    [self.delegate addFavoriteViewController:self didFinishWithSave:YES];
}

@end
