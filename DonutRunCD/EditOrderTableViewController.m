//
//  EditOrderTableViewController.m
//  DonutRunCD
//
//  Created by Lou Valencia on 11/10/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import "EditOrderTableViewController.h"
#import "EditOrderHeader.h"
#import "OrderBuilder.h"
#import "Person.h"

@interface EditOrderTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

#pragma mark -

@implementation EditOrderTableViewController

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // EditOrderHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"EditOrderHeader" owner:self options:nil] lastObject];
    // self.tableView.tableHeaderView = header;

    if ([self class] == [EditOrderTableViewController class]) {
        self.navigationItem.LeftBarButtonItem = self.editButtonItem;
    }
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // NSError *error;
    // [self.fetchedResultsController performFetch:&error];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavCell";
    OrderBuilderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

// Customize the appearance of table view cells.
- (void)configureCell:(OrderBuilderCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell to show the donut's flavor
    OrderBuilder *orderBuilder = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.personLabel.text = orderBuilder.person.name;
    cell.qtyLabel.text = orderBuilder.qty.description;
    // [cell.stepper addTarget:self action:@selector(stepperDidChange:) forControlEvents:UIControlEventAllEditingEvents];
}

- (IBAction)stepperDidChangeValue:(UIStepper *)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:
                              (UITableViewCell *)[[sender superview] superview]];
    OrderBuilder *orderBuilder = [self.fetchedResultsController objectAtIndexPath:indexPath];
    orderBuilder.qty = [NSNumber numberWithInt:sender.value];
    NSError *error;
    [self.managedObjectContext save:&error];
}

#pragma mark - Tableview editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    // Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    
    if (!editing) {
        // Save the changes.
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Fetched results controller

/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Donut entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderBuilder" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"person.name" ascending:YES];
    NSArray *sortDescriptors = @[nameDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"OrderBuilder"];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(OrderBuilderCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

#pragma mark - Navigation

- (IBAction)done:(UIBarButtonItem *)sender
{
    [self.delegate didFinishWithEditOrderTableViewController:self];
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddPeopleToOrder"]) {
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        AddPeopleToOrderTableViewController *addViewController = (AddPeopleToOrderTableViewController *)[navController topViewController];
        addViewController.delegate = self;
        addViewController.managedObjectContext = self.managedObjectContext;
    }
}

#pragma mark - Add view controller delegate

- (void)didFinishWithAddPeopleToOrderTableViewController:(AddPeopleToOrderTableViewController *)controller withArray:(NSArray *)array
{
    for (NSString *name in array) {
        // Create and configure a fetch request with the Person entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Create the sort descriptors array.
        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = @[nameDescriptor];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Set Predicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *matches = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if ([matches count] == 1) {
            OrderBuilder *newOrderBuilder = [NSEntityDescription insertNewObjectForEntityForName:@"OrderBuilder" inManagedObjectContext:self.managedObjectContext];
            newOrderBuilder.person = [matches lastObject];
        } else {
            // error
        }
    }
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.fetchedResultsController performFetch:&error];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
