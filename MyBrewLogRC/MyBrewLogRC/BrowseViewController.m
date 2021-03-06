// Elijah Freestone
// IPY 1504
// Week 3 - Release Candidate
// April 17th, 2015

//
//  BrowseViewController.m
//  MyBrewLogRC
//
//  Created by Elijah Freestone on 4/17/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "BrowseViewController.h"
#import "CustomTableViewCell.h"
#import "BrowseDetailsViewController.h"
#import <Parse/Parse.h>

@interface BrowseViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@end

//Create sort enum
typedef enum {
    SortDefault,
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
    NSIndexPath *selectedIndexPath;
    UIView *noRecipesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set parse class name
    parseClassName = @"newRecipe";
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.browseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.tableView.separatorColor = [UIColor lightGrayColor];
    
//    //Set offset and hide search bar
//    self.tableView.contentOffset = CGPointMake(0, (searchBar.frame.size.height) - self.tableView.contentOffset.y);
//    searchBar.hidden = YES;
    
    noRecipesView = [[UIView alloc] initWithFrame:self.view.frame];
    noRecipesView.backgroundColor = [UIColor clearColor];
    //Create and set no recpices label
    UILabel *noRecipesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, noRecipesView.frame.size.width, 200)];
    noRecipesLabel.font = [UIFont boldSystemFontOfSize:18];
    noRecipesLabel.numberOfLines = 1;
    noRecipesLabel.textColor = [UIColor darkGrayColor];
    noRecipesLabel.shadowOffset = CGSizeMake(0, 1);
    //noRecipesLabel.backgroundColor = [UIColor clearColor];
    noRecipesLabel.textAlignment = NSTextAlignmentCenter;
    noRecipesLabel.text = @"No Recipes to Show";
    //Hide no recipe view by default. Is shown if no recipes are available to show
    noRecipesView.hidden = YES;
    [noRecipesView addSubview:noRecipesLabel];
    [self.tableView insertSubview:noRecipesView belowSubview:self.tableView];
    
    //Set up and add searchbar
    self.browseSearchResults = [[NSMutableArray alloc] init];
    self.browseSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.browseSearchController.searchBar.delegate = self;
    self.browseSearchController.dimsBackgroundDuringPresentation = NO;
    self.browseSearchController.searchResultsUpdater = self;
    
    self.browseSearchController.searchBar.frame = CGRectMake(self.browseSearchController.searchBar.frame.origin.x, self.browseSearchController.searchBar.frame.origin.y, self.browseSearchController.searchBar.frame.size.width, 44.0);
    self.browseSearchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.tableView.tableHeaderView = self.browseSearchController.searchBar;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(IBAction)onSortClick:(id)sender {
//    if (searchBar.isHidden) {
//        self.tableView.contentOffset = CGPointMake(0, -searchBar.frame.size.height + self.tableView.contentOffset.y);
//        searchBar.hidden = NO;
//        NSLog(@"show");
//    } else if (!searchBar.isHidden) {
//        self.tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height + self.tableView.contentOffset.y);
//        searchBar.hidden = YES;
//        NSLog(@"hidden");
//    }
//}

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
    //Set ID for deque of cells
    static NSString *cellID = @"BrowseCell";
    CustomTableViewCell *browseCell = (CustomTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellID];
    
    //If browseSearchResults exists, populate table with search results
    if (self.browseSearchResults.count >= 1) {
        //NSLog(@"Search results controller");
        //Get object from browseSearchResults array instead of regular query
        PFObject *searchedObject = [self.browseSearchResults objectAtIndex:indexPath.row];
        NSString *recipeType = [searchedObject objectForKey:@"Type"];
        NSString *imageName;
        //Set the icon based on recipe type. "Other" is the default
        if ([recipeType isEqualToString:@"Beer"]) {
            imageName = @"beer-bottle.png";
        } else if ([recipeType isEqualToString:@"Wine"]) {
            imageName = @"wine-glass.png";
        } else {
            imageName = @"other-icon.png";
        }
        
        usernameString = [searchedObject objectForKey:@"createdBy"];
        NSString *createdByString = [NSString stringWithFormat:@"By: %@", usernameString];
        
        browseCell.recipeNameLabel.text = [searchedObject objectForKey:@"Name"];
        browseCell.detailsLabel.text = createdByString;
        browseCell.cellImage.image = [UIImage imageNamed:imageName];
    } else {
    //Not search, populate in regular manner
        //NSLog(@"ELSE Search results controller");
        NSString *recipeType = [object objectForKey:@"Type"];
        NSString *imageName;
        //Set the icon based on recipe type. "Other" is the default
        if ([recipeType isEqualToString:@"Beer"]) {
            imageName = @"beer-bottle.png";
        } else if ([recipeType isEqualToString:@"Wine"]) {
            imageName = @"wine-glass.png";
        } else {
            imageName = @"other-icon.png";
        }
        //Grab username to be displayed beow the recipe
        usernameString = [object objectForKey:@"createdBy"];
        NSString *createdByString = [NSString stringWithFormat:@"By: %@", usernameString];
        
        browseCell.recipeNameLabel.text = [object objectForKey:@"Name"];
        browseCell.detailsLabel.text = createdByString;
        browseCell.cellImage.image = [UIImage imageNamed:imageName];
    }
    
    //Override to remove extra seperator lines after the last cell
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
    
    //NSLog(@"Cell for row end");
    
    return browseCell;
} //cellForRowAtIndexPath close

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
//    if ([self.objects count] == 0) {
//        newItemQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
//    }
    
    //Set sort. toSort is an enum set by selecting a button in the sort action sheet
    switch (toSort) {
        case 1: //Favorites
            [newItemQuery whereKey:@"favorites" equalTo:[PFUser currentUser].objectId];
            [newItemQuery orderByDescending:@"updatedByUser"];
            NSLog(@"Sort favorites");
            break;
        case 2: //Username
            [newItemQuery orderByAscending:@"createdBy"];
            break;
        case 3: //Type
            [newItemQuery orderByAscending:@"Type"];
            break;
        case 4: //Newest
            [newItemQuery orderByDescending:@"updatedByUser"];
            //[self refreshTable];
            break;
        case 5://Oldest
            [newItemQuery orderByAscending:@"updatedByUser"];
            //[self refreshTable];
            break;
        default:
//            [newItemQuery orderByDescending:@"updatedByUser"];
            NSLog(@"Sort default");
            break;
    }
//    NSArray *queryResults = [newItemQuery findObjects];
//    [PFObject pinAllInBackground:queryResults];
    return newItemQuery;
} //queryForTable close

//Set number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.browseSearchResults.count == 0) {
        //Show/hide no recipes view based on count
        if (self.objects.count == 0) {
            noRecipesView.hidden = NO;
        } else {
            noRecipesView.hidden = YES;
        }
        return self.objects.count;
    } else {
        //Show/hide no recipes view based on count
        if (self.browseSearchResults.count == 0) {
            noRecipesView.hidden = NO;
        } else {
            noRecipesView.hidden = YES;
        }
        return self.browseSearchResults.count;
    }
}

//Fired whenever a tableview cell is selected, including when search active
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object;
    //If browseSearchResults exists, process as search table
    if (self.browseSearchResults.count >= 1) {
        //NSLog(@"indexpath at search tableview is: %ld", (long)indexPath.row);
        object = [self.browseSearchResults objectAtIndex:indexPath.row];
        selectedName = [object objectForKey:@"Name"];
        selectedType = [object objectForKey:@"Type"];
        selectedIngredients = [object objectForKey:@"Ingredients"];
        selectedInstructions = [object objectForKey:@"Instructions"];
        selectedObjectID = [NSString stringWithFormat:@"%@", object.objectId];
        selectedPFObject = object;
    } else {
        //Not search, process as standard selection
        //NSLog(@"indexpath at orignal tableview is: %@", [indexPath description]);
        object = [self objectAtIndexPath:indexPath];
        selectedName = [object objectForKey:@"Name"];
        selectedType = [object objectForKey:@"Type"];
        selectedIngredients = [object objectForKey:@"Ingredients"];
        selectedInstructions = [object objectForKey:@"Instructions"];
        selectedObjectID = [NSString stringWithFormat:@"%@", object.objectId];
        selectedPFObject = object;
    }
    
    //Grab destination view controller
    UIStoryboard *storyBoard = [self storyboard];
    BrowseDetailsViewController *detailsViewController = [storyBoard instantiateViewControllerWithIdentifier:@"BrowseDetails"];
    
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
    //Manually push details view
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

# pragma mark - ActionSheet (sort)

//Creat and show action sheet for sort
-(IBAction)showSortActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Recipes by:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Favorites", @"Username", @"Type", @"Newest", @"Oldest", nil];
    
    [actionSheet showInView:self.view];
}

//Grab tag of button pressed in sort action sheet and set enum to it
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    toSort = (int) buttonIndex + 1;
    //Reload table with new sort params
    [self loadObjects];
}

#pragma mark - Search

//Delegate method triggered when search text is entered
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    //[self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self filterResults:searchString];
    //[self.tableView reloadData];
}

//Filter query with search terms
-(void)filterResults:(NSString *)searchTerm {
    //Clear out search results array
    [self.browseSearchResults removeAllObjects];
    
    //Query with search term
    PFQuery *query = [PFQuery queryWithClassName: parseClassName];
    [query whereKey:@"createdBy" notEqualTo:[PFUser currentUser].username];
    [query whereKeyExists:@"Name"];  //this is based on whatever query you are trying to accomplish
    [query whereKeyExists:@"createdBy"]; //this is based on whatever query you are trying to accomplish
    [query whereKey:@"Name" containsString:searchTerm];
    
    NSArray *results  = [query findObjects];
    //    NSMutableArray *results;
    //    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
    //        [self.browseSearchResults addObjectsFromArray:objects];
    //
    //        [self.tableView reloadData];
    //    }];
    
    //NSLog(@"Result: %@", results);
    NSLog(@"filterResults %lu", (unsigned long)results.count);
    
    //Grab searchbar textfield to apply color and border when no results found
    UITextField *searchTextField;
    for (id object in [[[self.browseSearchController.searchBar subviews] objectAtIndex:0] subviews]) {
        if ([object isKindOfClass:[UITextField class]]) {
            searchTextField = (UITextField *)object;
            break;
        }
    }
    
    if (results.count == 0) {
        //self.browseSearchController.searchBar.backgroundColor = [UIColor grayColor];
        searchTextField.textColor = [UIColor redColor];
        searchTextField.layer.borderColor = [[UIColor redColor] CGColor];
        searchTextField.layer.borderWidth = 1.0;
    } else {
        //self.browseSearchController.searchBar.backgroundColor = [UIColor clearColor];
        searchTextField.textColor = [UIColor blackColor];
        searchTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
        searchTextField.layer.borderWidth = 0.0;
    }
    
    [self.browseSearchResults addObjectsFromArray:results];
    [self.tableView reloadData];
    //[self loadObjects];
}

//Cancel button on search bar clicked
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel button clicked");
    //Clear out search results array
    [self.browseSearchResults removeAllObjects];
}

#pragma mark - Navigation
//didSelectRowAtIndexPath is used instead of prepare for segue


@end
