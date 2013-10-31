//
//  FavoritesCell.m
//  DonutRunCD
//
//  Created by Lou Valencia on 10/30/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import "FavoritesCell.h"
#import "Donut.h"

@implementation FavoritesCell
@synthesize flavorLabel, qtyLabel, stepper;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// Customize the appearance of table view cells.
/*
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell to show the donut's flavor
    Donut *donut = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.flavorLabel.text = donut.flavor;
    self.qtyLabel.text = @"1";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavCell";
    FavoritesCell *cell = (FavoritesCell *)[tableView
        dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
