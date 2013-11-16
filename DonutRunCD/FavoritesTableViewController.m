//
//  FavoritesTableViewController.m
//  DonutRunCD
//
//  Created by Lou Valencia on 10/30/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "Person.h"
#import "Donut.h"

@interface FavoritesTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)updateInterface;
- (void)updateRightBarButtonItemState;

@end

#pragma mark -

@implementation FavoritesTableViewController

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Redisplay the data.
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
    // [self updateInterface];
    // [self updateRightBarButtonItemState];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self class] == [FavoritesTableViewController class]) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // if the locale changes behind our back, we need to be notified so we can update the date
    // format in the table view cells
    //
    /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil]; */
}

- (void)updateInterface {
    
    // UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FavCell"];
    // self.flavorLabel.text = self.donut.flavor;
}

- (void)updateRightBarButtonItemState {
    
    // Conditionally enable the right bar button item -- it should only be enabled if the person is in a valid state for saving.
    self.navigationItem.rightBarButtonItem.enabled = [self.person validateForUpdate:NULL];
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

- (FavoritesCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavCell";
    FavoritesCell *cell = (FavoritesCell *)[tableView
        dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

// Customize the appearance of table view cells.
- (void)configureCell:(FavoritesCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell to show the donut's flavor
    Donut *donut = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.flavorLabel.text = donut.flavor;
    cell.qtyLabel.text = donut.qty.description;
    // [cell.stepper addTarget:self action:@selector(stepperDidChange:) forControlEvents:UIControlEventAllEditingEvents];
}

- (IBAction)stepperDidChangeValue:(UIStepper *)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:
                              (UITableViewCell *)[[sender superview] superview]];
    Donut *donut = [self.fetchedResultsController objectAtIndexPath:indexPath];
    donut.qty = [NSNumber numberWithInt:sender.value];
    NSError *error;
    [self.managedObjectContext save:&error];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    int maxPathRow = sourceIndexPath.row > destinationIndexPath.row ? sourceIndexPath.row : destinationIndexPath.row;
    int minPathRow = sourceIndexPath.row < destinationIndexPath.row ? sourceIndexPath.row : destinationIndexPath.row;
    for (int i = minPathRow; i <= maxPathRow; i++) {
        NSIndexPath *thisPath = [NSIndexPath indexPathForRow:i inSection:0];
        Donut *donut = [self.fetchedResultsController objectAtIndexPath:thisPath];
        if (thisPath.row == sourceIndexPath.row) {
            donut.rank = [NSNumber numberWithInt:destinationIndexPath.row];
        } else if (sourceIndexPath.row > destinationIndexPath.row) {
            donut.rank = [NSNumber numberWithInt:thisPath.row + 1];
        } else {
            donut.rank = [NSNumber numberWithInt:thisPath.row - 1];
        }
    }
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

#pragma mark - Table view editing

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Rerank remaining rows
        for (int i = indexPath.row + 1; i < [[self.fetchedResultsController sections][0] numberOfObjects]; i++) {
            NSIndexPath *thisPath = [NSIndexPath indexPathForRow:i inSection:0];
            Donut *donut = [self.fetchedResultsController objectAtIndexPath:thisPath];
            donut.rank = [NSNumber numberWithInt:thisPath.row - 1];
        }
        
        // Delete the managed object.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error;
        if (![context save:&error]) {
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Donut" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *rankDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
    NSArray *sortDescriptors = @[rankDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Set Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner.name == %@", self.person.name];
    [fetchRequest setPredicate:predicate];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil]; // cacheName:@"Favorite"];
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
            [self configureCell:(FavoritesCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddFavorite"]) {
        
        /*
         The destination view controller for this segue is an AddViewController to manage addition of the person.
         This block creates a new managed object context as a child of the root view controller's context. It then creates a new person using the child context. This means that changes made to the person remain discrete from the application's managed object context until the person's context is saved.
         The root view controller sets itself as the delegate of the add controller so that it can be informed when the user has completed the add operation -- either saving or canceling (see addViewController:didFinishWithSave:).
         IMPORTANT: It's not necessary to use a second context for this. You could just use the existing context, which would simplify some of the code -- you wouldn't need to perform two saves, for example. This implementation, though, illustrates a pattern that may sometimes be useful (where you want to maintain a separate set of edits).
         */
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        AddFavoriteViewController *addViewController = (AddFavoriteViewController *)[navController topViewController];
        addViewController.delegate = self;
        
        // Create a new managed object context for the new donut; set its parent to the fetched results controller's context.
        addViewController.managedObjectContext = self.managedObjectContext;
        Donut *newDonut = (Donut *)[NSEntityDescription
                                       insertNewObjectForEntityForName:@"Donut"
                                       inManagedObjectContext:self.managedObjectContext];
        NSUInteger nextRow = [[self.fetchedResultsController sections][0] numberOfObjects];
        addViewController.rank = [NSNumber numberWithInteger:nextRow];
        addViewController.donut = newDonut;
        addViewController.person = self.person;
    }
}

#pragma mark - Add controller delegate

/*
 Add controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new person.
 */
- (void)addFavoriteViewController:(AddFavoriteViewController *)controller didFinishWithSave:(BOOL)save {
    
    if (save) {
        /*
         The new person is associated with the add controller's managed object context.
         This means that any edits that are made don't affect the application's main managed object context -- it's a way of keeping disjoint edits in a separate scratchpad. Saving changes to that context, though, only push changes to the fetched results controller's context. To save the changes to the persistent store, you have to save the fetch results controller's context as well.
        */
        NSError *error;
        NSManagedObjectContext *addingManagedObjectContext = [controller managedObjectContext];
        if (![addingManagedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        if (![[self.fetchedResultsController managedObjectContext] save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    /* } else {
        [self.managedObjectContext deleteObject:
            [self.fetchedResultsController objectAtIndexPath:
                [NSIndexPath indexPathForRow:0 inSection:0]]]; */
    }
    
    // Dismiss the modal view to return to the main list
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end