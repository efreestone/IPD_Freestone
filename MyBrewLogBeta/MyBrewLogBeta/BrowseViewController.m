// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  BrowseViewController.m
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "BrowseViewController.h"
#import "CustomTableViewCell.h"
#import "BrowseDetailsViewController.h"
#import <Parse/Parse.h>

@interface BrowseViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@end

//Create sort enum
typedef enum {
    SortFavorite,
    SortUsername,
    SortType,
    SortNewest,
    SortOldest
}sortEnum;

@implementation BrowseViewController {
    NSArray *recipesArray;
    NSArray *imageArray;
    IBOutlet UISearchBar *searchBar;
    NSString *parseClassName;
    NSString *usernameString;
    
    NSString *selectedName;
    NSString *selectedIngredients;
    NSString *selectedInstructions;
    NSString *selectedType;
    NSString *selectedObjectID;
    PFObject *selectedPFObject;
    //NSString *usernameString;
    sortEnum toSort;
    PFQuery *newItemQuery;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    toSort = 10;
    
    parseClassName = @"newRecipe";
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.browseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.tableView.separatorColor = [UIColor lightGrayColor];
    
    recipesArray = [NSArray arrayWithObjects:@"Secret IPA", @"Dry Red Wine", @"Cali Style Sourdough", @"My Choco Stout", @"Peach Wine #1", @"Yogurt Base", @"Super Lager", @"Sweet Apple Pie Mead", @"Green Tea Kombucha", @"Strawberry Blonde", @"My White Zin", @"Plum Sake", @"Earl Grey Kombucha", @"Just good ol' Ale", @"Raspberry Suprise", @"Moms Sourdough Bread", nil];
    
    imageArray = [NSArray arrayWithObjects:@"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", @"wine-glass.png", @"other-icon.png",@"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", nil];
    
//    //Set offset and hide search bar
//    self.tableView.contentOffset = CGPointMake(0, (searchBar.frame.size.height) - self.tableView.contentOffset.y);
//    searchBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadObjects];
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

#pragma mark - PFQueryTableViewController

//Use initWithCoder instead of initWithStyle to use my own stroyboard.
//This was not working in project 2 because parseClassName wasn't being set properly
- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        // The className to query on
        self.parseClassName = @"newRecipe";
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        // The title for this table in the Navigation Controller.
        //self.title = @"My Contacts";
    }
    return self;
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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

//Set up cells and apply objects from Parse
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellID = @"BrowseCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    CustomTableViewCell *browseCell = (CustomTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSString *recipeType = [object objectForKey:@"Type"];
    NSString *imageName;
    if ([recipeType isEqualToString:@"Beer"]) {
        imageName = @"beer-bottle.png";
    } else if ([recipeType isEqualToString:@"Wine"]) {
        imageName = @"wine-glass.png";
    } else {
        imageName = @"other-icon.png";
    }
    
    usernameString = [object objectForKey:@"createdBy"];
    NSString *createdByString = [NSString stringWithFormat:@"By: %@", usernameString];
    
    browseCell.recipeNameLabel.text = [object objectForKey:@"Name"];
    browseCell.detailsLabel.text = createdByString;
    //    cell.recipeNameLabel.text = [recipesArray objectAtIndex:indexPath.row];
    //cell.cellImage.image = [UIImage imageNamed:@"glasses.jpg"];
    browseCell.cellImage.image = [UIImage imageNamed:imageName];
    
    //Override to remove extra seperator lines after the last cell
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
    
    return browseCell;
} //cellForRowAtIndexPath close

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    PFObject *object = [self objectAtIndexPath:indexPath];
//    selectedName = [object objectForKey:@"Name"];
//    selectedIngredients = [object objectForKey:@"Ingredients"];
//    selectedInstructions = [object objectForKey:@"Instructions"];
//    selectedPFObject = object;
//}

//Override query to set cache policy an change sort
- (PFQuery *)queryForTable {
    //Make sure parseClassName is set
    if (!self.parseClassName) {
        self.parseClassName = @"newRecipe";
    }
    //Grab objects
    newItemQuery = [PFQuery queryWithClassName:self.parseClassName];
    //Exclude the current users objects
    [newItemQuery whereKey:@"createdBy" notEqualTo:[PFUser currentUser].username];
    
    //Set cache policy
    if ([self.objects count] == 0) {
        newItemQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    }
    
    //Set sort
    switch (toSort) {
        case 0: //Favorites
            [newItemQuery whereKey:@"favorites" equalTo:[PFUser currentUser].objectId];
            [newItemQuery orderByDescending:@"updatedByUser"];
            break;
        case 1: //Username
            [newItemQuery orderByAscending:@"createdBy"];
            break;
        case 2: //Type
            [newItemQuery orderByAscending:@"Type"];
            break;
        case 3: //Newest
            [newItemQuery orderByDescending:@"updatedByUser"];
            //[self refreshTable];
            break;
        case 4://Oldest
            [newItemQuery orderByAscending:@"updatedByUser"];
            //[self refreshTable];
            break;
        default:
            //[newItemQuery orderByDescending:@"updatedByUser"];
            break;
    }
    
    //Set sort
//    [newItemQuery orderByDescending:@"updatedByUser"];
    return newItemQuery;
} //queryForTable close

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.objects.count;
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

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    toSort = (int) buttonIndex;
//    if (toSort == 0) {
//        [newItemQuery whereKey:@"favorites" equalTo:[PFUser currentUser].objectId];
//    }
    
    [self loadObjects];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    PFObject *object = [self objectAtIndexPath:indexPath];
    selectedName = [object objectForKey:@"Name"];
    selectedType = [object objectForKey:@"Type"];
    selectedIngredients = [object objectForKey:@"Ingredients"];
    selectedInstructions = [object objectForKey:@"Instructions"];
    selectedObjectID = [NSString stringWithFormat:@"%@", object.objectId];
    selectedPFObject = object;
    
    //Verify identifier of push segue to Details view
    if ([segue.identifier isEqualToString:@"BrowseDetail"]) {
        //Grab destination view controller
        BrowseDetailsViewController *detailsViewController = segue.destinationViewController;
        //Pass details over to be displayed
        if (detailsViewController != nil) {
            detailsViewController.passedName = selectedName;
            detailsViewController.passedType = selectedType;
            detailsViewController.passedIngredients = selectedIngredients;
            detailsViewController.passedInstructions = selectedInstructions;
            detailsViewController.passedUsername = usernameString;
            detailsViewController.passedObjectID = selectedObjectID;
            detailsViewController.passedObject = selectedPFObject;
        }
    }
}


@end
