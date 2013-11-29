//
//  OrderTableViewController.m
//  DonutRunCD
//
//  Created by Lou Valencia on 11/10/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import "OrderTableViewController.h"
#import "Person.h"
#import "Donut.h"
#import "Order.h"

@interface OrderTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation OrderTableViewController

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

    /*
     if ([self class] == [OrderTableViewController class]) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    self.tableView.allowsSelectionDuringEditing = YES;
    */
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // [self clearOrder];
    [self updateOrderModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)clearOrder
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:self.managedObjectContext];
    [req setEntity:ent];
    NSArray *results = [self.managedObjectContext executeFetchRequest:req error:nil];
    for (Order *result in results) {
        [self.managedObjectContext deleteObject:result];
    }
    [self.managedObjectContext save:nil];
}

- (void)updateOrderModel
{
    // Clear out all Order data and start fresh.
    [self clearOrder];
    
    // Create and configure a fetch request with the Person entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *rankDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[rankDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Set Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inOrder != 0"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *matches = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([matches count] == 0) NSLog(@"No matches");
    for (Person *match in matches) {  // iterates through each person ordering.
        int remainInOrder = [match.qtyInOrder intValue];
        for (int i = 0; i < remainInOrder; i++) {  // iterates through each donut for order.
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rank = %@", @(i)];  // sets up the predicate and ...
            NSSet *filteredSet = [match.favorites filteredSetUsingPredicate:predicate];  // eliminates all donuts, leaving the one who's rank matches i.
            Donut *thisDonut = (Donut *)[filteredSet anyObject];  // sets Donut *thisDonut to that donut.
            BOOL stored = NO;
            for (Order *order in [self.fetchedResultsController fetchedObjects]) {  // stores donut in previously made order.
                if ([((Donut *)[order.donutItems anyObject]).flavor isEqualToString:thisDonut.flavor]) {
                    order.qty = @([order.qty integerValue] + [thisDonut.qty integerValue]);
                    remainInOrder -= [thisDonut.qty intValue] - 1;
                    [order addDonutItemsObject:thisDonut];
                    NSLog(@"order: %@(%d), %@ : order.qty=%@.", match.name, i, thisDonut.flavor, order.qty.description);
                    stored = YES;
                    break;
                }
            }
            if (!stored) {  // creates new order for donut when a pre-existing one is not found.
                Order *newOrder = (Order *)[NSEntityDescription
                                            insertNewObjectForEntityForName:@"Order"
                                            inManagedObjectContext:self.managedObjectContext];
                NSUInteger nextRow = [[self.fetchedResultsController sections][0] numberOfObjects];
                newOrder.rank = [NSNumber numberWithInteger:nextRow];
                newOrder.qty = thisDonut.qty;
                remainInOrder -= [thisDonut.qty intValue] - 1;
                [newOrder addDonutItemsObject:thisDonut];
                NSLog(@"newOrder: %@(%d), %@ : newOrder.qty=%@.", match.name, i, thisDonut.flavor, newOrder.qty.description);
            }
            [self.fetchedResultsController performFetch:&error];
        }
    }
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
}

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
    static NSString *CellIdentifier = @"OrderCell";
    OrderCell *cell = (OrderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UISwipeGestureRecognizer *swipeCell = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
    [swipeCell setDirection:UISwipeGestureRecognizerDirectionRight];
    [cell addGestureRecognizer:swipeCell];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

// Customize the appearance of table view cells.
- (void)configureCell:(OrderCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell to show the donut's flavor
    Order *order = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Donut *donut = [order.donutItems anyObject];
    cell.qtyLabel.text = order.qty.description;
    cell.donutLabel.text = donut.flavor;
}

#define DURATION 0.2

- (void)cellSwiped:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"direction: %d, state: %d", recognizer.direction, recognizer.state);
    CGPoint p = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    /*
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.layer setAnchorPoint:CGPointMake(0, 0.5)];
    [cell.layer setPosition:CGPointMake(cell.frame.size.width, cell.layer.position.y)];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [animation setRemovedOnCompletion:NO];
    [animation setDelegate:self];
    [animation setDuration:DURATION];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [cell.layer addAnimation:animation forKey:@"reveal"];
    */
    [self.managedObjectContext deleteObject:[[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row]];
    // [self.tableView reloadData];
    
    // [self.managedObjectContext insertObject:[[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row]];
    // [self.tableView reloadData];
    
    Order *newOrder = (Order *)[NSEntityDescription
                                insertNewObjectForEntityForName:@"Order"
                                inManagedObjectContext:self.managedObjectContext];
    newOrder.rank = [NSNumber numberWithInteger:indexPath.row];
    newOrder.qty = @(-1);
    Donut *newDonut = (Donut *)[NSEntityDescription
                                insertNewObjectForEntityForName:@"Donut"
                                inManagedObjectContext:self.managedObjectContext];
    newDonut.rank = @(1);
    newDonut.flavor = @"Fake Entry";
    [newOrder addDonutItemsObject:newDonut];
    
    Order *secondOrder = (Order *)[NSEntityDescription
                                insertNewObjectForEntityForName:@"Order"
                                inManagedObjectContext:self.managedObjectContext];
    secondOrder.rank = [NSNumber numberWithInteger:indexPath.row + 1];
    secondOrder.qty = @(-2);
    Donut *secondDonut = (Donut *)[NSEntityDescription
                                insertNewObjectForEntityForName:@"Donut"
                                inManagedObjectContext:self.managedObjectContext];
    secondDonut.rank = @(2);
    secondDonut.flavor = @"Another Entry";
    [secondOrder addDonutItemsObject:secondDonut];
    /*
    NSError *error;
    [self.managedObjectContext save:&error];
    [self.fetchedResultsController performFetch:&error];
    */
    // NSLog(@"newOrder: %@(%d), %@ : newOrder.qty=%@.", match.name, i, thisDonut.flavor, newOrder.qty.description);
}

/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    int maxPathRow = sourceIndexPath.row > destinationIndexPath.row ? sourceIndexPath.row : destinationIndexPath.row;
    int minPathRow = sourceIndexPath.row < destinationIndexPath.row ? sourceIndexPath.row : destinationIndexPath.row;
    for (int i = minPathRow; i <= maxPathRow; i++) {
        NSIndexPath *thisPath = [NSIndexPath indexPathForRow:i inSection:0];
        Order *order = [self.fetchedResultsController objectAtIndexPath:thisPath];
        if (thisPath.row == sourceIndexPath.row) {
            order.rank = [NSNumber numberWithInt:destinationIndexPath.row];
        } else if (sourceIndexPath.row > destinationIndexPath.row) {
            order.rank = [NSNumber numberWithInt:thisPath.row + 1];
        } else {
            order.rank = [NSNumber numberWithInt:thisPath.row - 1];
        }
    }
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}
*/

#pragma mark - Table view editing
/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    // [super setEditing:editing animated:animated];
    
    // Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    
    self.tableView.editing = NO;
    
    if (!editing) {
        // Save the changes.
        NSError *error;
        if (![self.managedObjectContext save:&error]) { */
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            */
            /* NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
} */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Rerank remaining rows
        for (int i = indexPath.row + 1; i < [[self.fetchedResultsController sections][0] numberOfObjects]; i++) {
            NSIndexPath *thisPath = [NSIndexPath indexPathForRow:i inSection:0];
            Order *order = [self.fetchedResultsController objectAtIndexPath:thisPath];
            order.rank = [NSNumber numberWithInt:thisPath.row - 1];
        }
        
        // Delete the managed object.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error;
        if (![context save:&error]) { */
             /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            */
            /* NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
*/
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OrderCell *cell = (OrderCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.qtyLabel.textColor == [UIColor blackColor]) {
        cell.qtyLabel.textColor = [UIColor grayColor];
        cell.donutLabel.textColor = [UIColor grayColor];
    } else {
        cell.qtyLabel.textColor = [UIColor blackColor];
        cell.donutLabel.textColor = [UIColor blackColor];
    }
}

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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *rankDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
    NSArray *sortDescriptors = @[rankDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Order"];
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
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(OrderCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowPeople"]) {
        UINavigationController *navController = [segue destinationViewController];
        PeopleTableViewController *peopleViewController = (PeopleTableViewController *)[navController topViewController];
        peopleViewController.delegate = self;
        peopleViewController.managedObjectContext = self.managedObjectContext;
    } else if ([[segue identifier] isEqualToString:@"EditOrder"]) {
        UINavigationController *navController = [segue destinationViewController];
        EditOrderTableViewController *editViewController = (EditOrderTableViewController *)[navController topViewController];
        editViewController.delegate = self;
        editViewController.managedObjectContext = self.managedObjectContext;
    }
}

- (void)didFinishWithPeopleTableViewController:(PeopleTableViewController *)controller
{
    // Dismiss the modal view to return to the main list
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFinishWithEditOrderTableViewController:(EditOrderTableViewController *)controller
{
    // Dismiss the modal view to return to the main list
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
