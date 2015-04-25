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
    BOOL shouldMoveCursor;
}

@end

@implementation LogViewController

//Synthesize for getters/setters
@synthesize titleString, notesString, passedObject, notesTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set title of the view
    self.navBar.topItem.title = [NSString stringWithFormat:@"Log for %@", titleString];
    
    //Register for keyboard notifications
    [self registerForKeyboardNotifications];
    
    //Set placeholder text
    placeholderString = @"This is a place for you to jot down and keep track of progess related stuff for your recipe. An example could be\n \"1-1-15 gravity at 1.040. Moving to carboy\"\n but feel free to use this as you see fit. This is NOT shared with your recipe so other users will not see it.";
    //If noteString is empty, replace with placeholder
    if (notesString == nil || [notesString isEqualToString:@""]) {
        //Set placeholder text if no notes exist for the recipe
        notesString = placeholderString;
        isPlaceholder = YES;
        notesTextView.textColor = [UIColor lightGrayColor];
    }
    //Apply notes to textview. This is placeholder text if no notes exist
    notesTextView.text = notesString;
    
    //Add border and corner radius to textview
    [[notesTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[notesTextView layer] setBorderWidth:0.5];
    [[notesTextView layer] setCornerRadius:7.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Save notes if any were entered and dismiss log view
-(IBAction)doneClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Make sure notes were entered and save if they were
    if (![notesTextView.text isEqualToString:@""] && ![notesTextView.text isEqualToString:placeholderString]) {
        NSLog(@"Notes were entered");
        passedObject[@"Notes"] = notesTextView.text;
        [passedObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Note saved.");
                //Pass notes back to details. This is to avoid needing to requery for the recipe on details to get new note (ie user clicks done after entering notes, and then clicks Log again)
                self.detailsVC.passedNotes = notesTextView.text;
            } else {
                NSLog(@"%@", error);
                //Error alert
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"An error occured trying to save the note. Please try again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            }
        }];
    }
}

//Did begin editing. Called when textview is selected
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if (isPlaceholder) {
        notesTextView.text = @"";
        NSLog(@"isPlaceholder");
        isPlaceholder = NO;
        notesTextView.textColor = [UIColor blackColor];
    }
    
//    NSUInteger length = notesTextView.text.length;
//    //notesTextView.selectedRange = NSMakeRange(0, length);
//    notesTextView.selectedRange = NSMakeRange(length, 0);
//    NSRange currentRange = [notesTextView selectedRange];
//    
//    [notesTextView scrollRangeToVisible:currentRange];
//    if (notesTextView.text.length > 0) {
//        NSLog(@"Is greater");
//        // Get current selected range , this example assumes is an insertion point or empty selection
//        UITextRange *selectedRange = [notesTextView selectedTextRange];
//        
//        // Calculate the new position, - for left and + for right
//        UITextPosition *newPosition = [notesTextView positionFromPosition:selectedRange.start offset:-5];
//        
//        // Construct a new range using the object that adopts the UITextInput, our textfield
//        UITextRange *newRange = [notesTextView textRangeFromPosition:newPosition toPosition:selectedRange.start];
//        
//        // Set new range
//        [notesTextView setSelectedTextRange:newRange];
//    }
//    notesTextView.selectedTextRange = [notesTextView
//                                   textRangeFromPosition:notesTextView.beginningOfDocument
//                                   toPosition:notesTextView.endOfDocument];
    shouldMoveCursor = YES;
}


- (void)textViewDidChangeSelection:(UITextView *)textView {
    if(shouldMoveCursor) {
        NSRange endRange = NSMakeRange(notesTextView.text.length, 0);
        NSRange currentRange = [textView selectedRange];
        if(!NSEqualRanges(endRange, currentRange))
            [textView setSelectedRange:endRange];
        shouldMoveCursor = NO;
    }
}

//Dismiss keyboard whenever user touches outside of the textview
-(IBAction)dismissKeyboard:(id)sender {
    [notesTextView resignFirstResponder];
}

//Register for notifications from the keyboard
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardAppeared:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//Called when keyboard notifies appearing
- (void)keyboardAppeared:(NSNotification*)notification {
    //Grab keyboard height and create CGSize and inset
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    notesTextView.contentInset = contentInsets;
    notesTextView.scrollIndicatorInsets = contentInsets;
    
    //Grab rect of frame and check it against keyboard, only scrolling when keyboard covers text position
    CGRect myRect = self.view.frame;
    myRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(myRect, notesTextView.frame.origin) ) {
        [notesTextView scrollRectToVisible:notesTextView.frame animated:YES];
    }
    //[notesTextView setContentOffset:CGPointMake(0.0, notesTextView.frame.origin.y - keyboardSize.height + 150) animated:YES];
}

//Called when keyboard notifies disappearing
- (void)keyboardHidden:(NSNotification*)notification {
    notesTextView.contentInset = UIEdgeInsetsZero;
    notesTextView.scrollIndicatorInsets = UIEdgeInsetsZero;
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
