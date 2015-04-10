// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  BrowseDetailsViewController.m
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "BrowseDetailsViewController.h"

@interface BrowseDetailsViewController () {
    NSArray *recipesArray;
    NSArray *listItems;
}

@end

@implementation BrowseDetailsViewController

//Synthesize for getters/setters
@synthesize ingredientsTV, instructionsTV;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *testString = @"ingredient 1 \nTimer: ingredient 2 \ningredient 3 \ningredient 4 \ningredient 5 \ningredient 6 \ningredient 7 \ningredient 8 \ningredient 9 \ningredient 10";
    
    listItems = [testString componentsSeparatedByString:@"\n"];
    NSLog(@"%@", listItems);
    NSLog(@"%lu", (unsigned long)listItems.count);
    
    recipesArray = [NSArray arrayWithObjects:@"Secret IPA", @"Timer: Dry Red Wine", @"Cali Style Sourdough", @"My Choco Stout", @"Peach Wine #1", @"Yogurt Base", @"Super Lager", @"Sweet Apple Pie Mead", @"Green Tea Kombucha", @"Strawberry Blonde", @"My White Zin", @"Plum Sake", @"Timer: Earl Grey Kombucha", @"Just good ol' Ale", @"Raspberry Suprise", @"Moms Sourdough Bread this is a longer string with more text blah blah blah blah", nil];
    
    ingredientsTV.text = testString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)recipeCopied:(id)sender {
    NSString *titleString = @"Copy Recipe";
    NSString *alertMessage = @"Recipe would have copied to My Recipes, however this feature is not functional yet";
    [self showAlert:alertMessage withTitle:titleString];
}

-(IBAction)shareClicked:(id)sender {
    NSString *titleString = @"Share Recipe";
    NSString *alertMessage = @"Recipe would have been shared via social networks, however this feature is not functional yet";
    [self showAlert:alertMessage withTitle:titleString];
}

-(IBAction)favoriteClicked:(id)sender {
    NSString *titleString = @"Favorite Recipe";
    NSString *alertMessage = @"Recipe would have been added to Favorite Recipes, however this feature is not functional yet";
    [self showAlert:alertMessage withTitle:titleString];
}

//Method to create and show alert view
-(void)showAlert:(NSString *)alertMessage withTitle:(NSString *)titleString {
    UIAlertView *copyAlert = [[UIAlertView alloc] initWithTitle:titleString message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //Show alert
    [copyAlert show];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return [recipesArray count];
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    // If you're serving data from an array, return the length of the array:
//    return [listItems count];
//}
//
//// Customize the appearance of table view cells.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    // Set the data for this cell:
//    cell.textLabel.text = [listItems objectAtIndex:indexPath.row];
//    
//    return cell;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGSize size = [[listItems objectAtIndex:indexPath.row]
//                   sizeWithFont:[UIFont systemFontOfSize:14]
//                   constrainedToSize:CGSizeMake(400, CGFLOAT_MAX)];
//    return size.height + 1;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *selectedCell = [listItems objectAtIndex:indexPath.row];
//    NSString *firstSix;
//    if (selectedCell.length >= 3) {
//        firstSix = [selectedCell substringToIndex:6];
//        NSLog(@"first six %@", firstSix);
//    }
//    
//    if ([selectedCell isEqualToString:@"Timer:"]) {
//        NSLog(@"Timer selected");
//    }
//}



@end
