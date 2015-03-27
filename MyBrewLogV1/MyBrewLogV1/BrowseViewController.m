// Elijah Freestone
// IPD1 1503
// Week 3
// March 18th, 2015

//
//  SecondViewController.m
//  MyBrewLogV1
//
//  Created by Elijah Freestone on 3/18/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "BrowseViewController.h"
#import "CustomTableViewCell.h"

@interface BrowseViewController () <UITableViewDelegate, UITableViewDataSource>

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
    
    //Set offset and hide search bar
    self.tableView.contentOffset = CGPointMake(0, (searchBar.frame.size.height) - self.tableView.contentOffset.y);
    searchBar.hidden = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
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

@end
