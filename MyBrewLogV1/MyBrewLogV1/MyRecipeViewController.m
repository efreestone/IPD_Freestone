// Elijah Freestone
// IPD1 1503
// Week 3
// March 18th, 2015

//
//  FirstViewController.m
//  MyBrewLogV1
//
//  Created by Elijah Freestone on 3/18/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "MyRecipeViewController.h"
#import "CustomTableViewCell.h"
#import "AppDelegate.h"
#import <ParseUI/ParseUI.h>

@interface MyRecipeViewController () <UITableViewDelegate, UITableViewDataSource, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate> 

@end

@implementation MyRecipeViewController {
    NSArray *recipesArray;
    IBOutlet UISearchBar *searchBar;
    CGRect originalSearchFrameRect;
    CGRect searchFrameRect;
    CGFloat zeroFloat;
    BOOL scopeButtonsHidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    originalSearchFrameRect = searchBar.frame;
    searchFrameRect = searchBar.frame;
    zeroFloat = 0;
    
    searchFrameRect.size.height = zeroFloat;
    
//    myRecipeVC = self;
    
    recipesArray = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    //Set offset and hide search bar
    self.tableView.contentOffset = CGPointMake(0, (searchBar.frame.size.height) - self.tableView.contentOffset.y);
    searchBar.hidden = YES;
    //searchBar.frame = searchFrameRect;
    scopeButtonsHidden = YES;
    
    
    //Grab user and username
    PFUser *user = [PFUser currentUser];
    NSString *usernameString = [user objectForKey:@"username"];
    
    if ([PFUser currentUser]) {
        //Log username if user is logged in
        NSLog(@"%@ is logged in", usernameString);
    }
    
    //Test parse
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
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

-(IBAction)onSortClick:(id)sender {
    if (searchBar.isHidden) {
        self.tableView.contentOffset = CGPointMake(0, -searchBar.frame.size.height + self.tableView.contentOffset.y);
        searchBar.hidden = NO;
//        searchBar.showsScopeBar = YES;
//        [searchBar sizeToFit];
        scopeButtonsHidden = NO;
        NSLog(@"show");
        //searchBar.frame = originalSearchFrameRect;
    } else if (!searchBar.isHidden) {
//        CGFloat zero = 0;
//        searchFrameRect.size.height = zero;
        self.tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height + self.tableView.contentOffset.y);
        searchBar.hidden = YES;
//        searchBar.showsScopeBar = NO;
//        scopeButtonsHidden = YES;
        NSLog(@"hidden");
//        searchBar.frame = searchFrameRect;
    }
    
}

//Check if user is logged in, present login if not
-(void)isUserLoggedIn {
    NSLog(@"isUserLoggedIn called");
    if (![PFUser currentUser]) { // No user logged in
        NSLog(@"No user logged in");
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    } else {
        NSLog(@"User is logged in from isUserLoggedIn");
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
    static NSString *cellID = @"MyRecipeCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    CustomTableViewCell *cell = (CustomTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.recipeNameLabel.text = [recipesArray objectAtIndex:indexPath.row];
    cell.cellImage.image = [UIImage imageNamed:@"glasses.jpg"];
    
    //Override to remove extra seperator lines after the last cell
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];
    
    return cell;
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

@end
