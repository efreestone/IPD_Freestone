// Elijah Freestone
// IPY 1504
// Week 3 - Release Candidate
// April 17th, 2015

//
//  LogViewController.m
//  MyBrewLogRC
//
//  Created by Elijah Freestone on 4/25/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController () <UITextViewDelegate> {
    BOOL isPlaceholder;
    NSString *placeholderString;
}

@end

@implementation LogViewController

//Synthesize for getters/setters
@synthesize titleString, notesString, passedObject, notesTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.topItem.title = [NSString stringWithFormat:@"Log for %@", titleString];
    
    placeholderString = @"This is a place for you to jot down and keep track of progess related stuff for your recipe. An example could be\n \"1-1-15 gravity at 1.040. Moving to carboy\"\n but feel free to use this as you see fit. This is NOT shared with your recipe so other users will not see it.";
    
    if (notesString == nil || [notesString isEqualToString:@""]) {
        //Set placeholder text if no notes exist for the recipe
        notesString = placeholderString;
        isPlaceholder = YES;
        notesTextView.textColor = [UIColor lightGrayColor];
    }
    
    notesTextView.text = notesString;
    
    [[notesTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[notesTextView layer] setBorderWidth:0.5];
    [[notesTextView layer] setCornerRadius:7.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doneClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    passedObject[@"Notes"] = notesTextView.text;
    
    if (![notesTextView.text isEqualToString:@""] && ![notesTextView.text isEqualToString:placeholderString]) {
        NSLog(@"Notes were entered");
        [passedObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Note saved.");
            } else {
                NSLog(@"%@", error);
                //Error alert
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"An error occured trying to save the note. Please try again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            }
        }];
        self.detailsVC.passedNotes = notesTextView.text;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if (isPlaceholder) {
        notesTextView.text = @"";
        NSLog(@"isPlaceholder");
        isPlaceholder = NO;
        notesTextView.textColor = [UIColor blackColor];
    }
}

-(IBAction)dismissKeyboard:(id)sender {
    [notesTextView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
