// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  MyRecipeViewController.m
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "MyRecipeViewController.h"
#import "CustomTableViewCell.h"
#import "AppDelegate.h"
#import "NewRecipeViewController.h"
#import "RecipeDetailsViewController.h"
#import <ParseUI/ParseUI.h>
#import "CustomPFLoginViewController.h"
#import "CustomPFSignUpViewController.h"

@interface MyRecipeViewController () <UITableViewDelegate, UITableViewDataSource, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIActionSheetDelegate>

@end

@implementation MyRecipeViewController {
    NSArray *recipesArray;
    NSArray *imageArray;
    IBOutlet UISearchBar *searchBar;
    NSString *parseClassName;
    
    NSString *selectedName;
    NSString *selectedIngredients;
    NSString *selectedInstructions;
    NSString *selectedType;
    NSString *selectedObjectID;
    PFObject *selectedPFObject;
    NSString *usernameString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set default ACL to be read/write of current user only
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    parseClassName = @"newRecipe";
    
    //Set seperators. Not sure why but they disappeared after hooking up Parse
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.tableView.separatorColor = [UIColor lightGrayColor];
    
    recipesArray = [NSArray arrayWithObjects:@"Secret IPA", @"Dry Red Wine", @"Cali Style Sourdough", @"My Choco Stout", @"Peach Wine #1", @"Yogurt Base", @"Super Lager", @"Sweet Apple Pie Mead", @"Green Tea Kombucha", @"Strawberry Blonde", @"My White Zin", @"Plum Sake", @"Earl Grey Kombucha", @"Just good ol' Ale", @"Raspberry Suprise", @"Moms Sourdough Bread", nil];
    
    imageArray = [NSArray arrayWithObjects:@"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", @"wine-glass.png", @"other-icon.png",@"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", @"wine-glass.png", @"other-icon.png", @"beer-bottle.png", nil];
    
    //Grab user and username
    PFUser *user = [PFUser currentUser];
    usernameString = [user objectForKey:@"username"];
    
    if ([PFUser currentUser]) {
        //Log username if user is logged in
        NSLog(@"%@ is logged in", usernameString);
    }
    
    //    [self.myTableView setEditing:YES animated:YES];
    
    //Test parse
    //    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //    testObject[@"foo"] = @"bar";
    //    [testObject saveInBackground];
}

-(void)viewWillAppear:(BOOL)animated {
    [self refreshTable];
}

-(IBAction)showNewRecipeView:(id)sender {
    UIStoryboard *storyBoard = [self storyboard];
    NewRecipeViewController *newRecipeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"NewRecipe"];
    newRecipeViewController.myRecipeVC = self;
    //[self.navigationController popoverPresentationController:newRecipeViewController animated:true];
    [self presentViewController:newRecipeViewController animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //Check if user is logged in, in viewDidAppear to be checked whenever this tab is shown
    //This is used to present the login again after the user logs out on settings
    [self isUserLoggedIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Check if user is logged in, present login if not
-(void)isUserLoggedIn {
    NSLog(@"isUserLoggedIn called");
    if (![PFUser currentUser]) { // No user logged in
        NSLog(@"No user logged in");
        // Create the log in view controller
        CustomPFLoginViewController *logInViewController = [[CustomPFLoginViewController alloc] init];
        //        logInViewController.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash-logo.png"]];
        //        logInViewController.logInView.logo.frame = CGRectMake(0, 0, 370, 170.6);
        
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        CustomPFSignUpViewController *signUpViewController = [[CustomPFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    } else {
        NSLog(@"User is logged in from isUserLoggedIn");
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
    static NSString *cellID = @"MyRecipeCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    CustomTableViewCell *cell = (CustomTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSString *recipeType = [object objectForKey:@"Type"];
    NSString *imageName;
    if ([recipeType isEqualToString:@"Beer"]) {
        imageName = @"beer-bottle.png";
    } else if ([recipeType isEqualToString:@"Wine"]) {
        imageName = @"wine-glass.png";
    } else {
        imageName = @"other-icon.png";
    }
    
    NSDate *updated = [object updatedAt];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yy"];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Lasted Updated: %@", [dateFormat stringFromDate:updated]];
    NSString *createdAtString = [NSString stringWithFormat:@"Created %@",[dateFormat stringFromDate:updated]];
    
    cell.recipeNameLabel.text = [object objectForKey:@"Name"];
    cell.detailsLabel.text = createdAtString;
    //    cell.recipeNameLabel.text = [recipesArray objectAtIndex:indexPath.row];
    //cell.cellImage.image = [UIImage imageNamed:@"glasses.jpg"];
    cell.cellImage.image = [UIImage imageNamed:imageName];
    
    //Override to remove extra seperator lines after the last cell
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
    
    return cell;
} //cellForRowAtIndexPath close

-(void)refreshTable {
    [self loadObjects];
}

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
    PFQuery *newItemQuery = [PFQuery queryWithClassName:self.parseClassName];
    //Include only recipes for current user.
    //This does not work correctly if using usernameString for requalTo. Not sure why
    [newItemQuery whereKey:@"createdBy" equalTo:[PFUser currentUser].username];

    //Set cache policy
    if ([self.objects count] == 0) {
        newItemQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    }
    //Set sort
    [newItemQuery orderByDescending:@"updatedAt"];
    return newItemQuery;
} //queryForTable close

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.objects.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadObjects];
        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

# pragma mark - ActionSheet (sort)

-(IBAction)showSortActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Recipes by:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Active", @"Name", @"Type", @"Newest", @"Oldest", nil];
    
    [actionSheet showInView:self.view];
    
}

#pragma mark - PFLogInViewControllerDelegate

//These are defualt delegate methods for the Parse Login and are essentially unmodified. Added to get basic use of the login/signup framework Parse provides
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}

#pragma mark - PFSignUpViewControllerDelegate

//These are defualt delegate methods for the Parse Signup and are essentially unmodified. Added to get basic use of the login/signup framework Parse provides
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

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
    if ([segue.identifier isEqualToString:@"DetailView"]) {
        //Grab destination view controller
        RecipeDetailsViewController *detailsViewController = segue.destinationViewController;
        //Pass details over to be displayed
        if (detailsViewController != nil) {
            detailsViewController.passedName = selectedName;
            detailsViewController.passedType = selectedType;
            detailsViewController.passedIngredients = selectedIngredients;
            detailsViewController.passedInstructions = selectedInstructions;
            detailsViewController.passedObjectID = selectedObjectID;
            detailsViewController.passedObject = selectedPFObject;
        }
    }
}

@end
