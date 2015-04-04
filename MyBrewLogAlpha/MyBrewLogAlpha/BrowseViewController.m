// Elijah Freestone
// IPY 1504
// Week 1 - Alpha
// March 30th, 2015

//
//  BrowseViewController.m
//  MyBrewLogAlpha
//
//  Created by Elijah Freestone on 3/30/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "BrowseViewController.h"
#import "CustomTableViewCell.h"

@interface BrowseViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@end

@implementation BrowseViewController {
    NSArray *recipesArray;
    NSArray *imageArray;
    IBOutlet UISearchBar *searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    recipesArray = [NSArray arrayWithObjects:@"Secret IPA", @"Dry Red Wine", @"Cali Style Sourdough", @"My Choco Stout", @"Peach Wine #1", @"Yogurt Base", @"Super Lager", @"Sweet Apple Pie Mead", @"Green Tea Kombucha", @"Strawberry Blonde", @"My White Zin", @"Plum Sake", @"Earl Grey Kombucha", @"Just good ol' Ale", @"Raspberry Suprise", @"Moms Sourdough Bread", nil];
    
    imageArray = [NSArray arrayWithObjects:@"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", @"wine-glass.png", @"other-icon.png",@"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", nil];
    
//    //Set offset and hide search bar
//    self.tableView.contentOffset = CGPointMake(0, (searchBar.frame.size.height) - self.tableView.contentOffset.y);
//    searchBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onSortClick:(id)sender {
    if (searchBar.isHidden) {
        self.tableView.contentOffset = CGPointMake(0, -searchBar.frame.size.height + self.tableView.contentOffset.y);
        searchBar.hidden = NO;
        NSLog(@"show");
    } else if (!searchBar.isHidden) {
        self.tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height + self.tableView.contentOffset.y);
        searchBar.hidden = YES;
        NSLog(@"hidden");
    }
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipesArray count];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BrowseCell";
    
    CustomTableViewCell *cell = (CustomTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.recipeNameLabel.text = [recipesArray objectAtIndex:indexPath.row];
    //cell.cellImage.image = [UIImage imageNamed:@"barrels.jpg"];
    cell.cellImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    
    //Override to remove extra seperator lines after the last cell
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
    
    return cell;
}

# pragma mark - ActionSheet (sort)

-(IBAction)showSortActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Recipes by:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Favorites", @"Username", @"Type", @"Newest", @"Oldest", nil];
    
    [actionSheet showInView:self.view];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
