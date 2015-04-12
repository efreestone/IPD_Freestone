// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  RecipeDetailsViewController.m
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "RecipeDetailsViewController.h"
#import "NewRecipeViewController.h"

@interface RecipeDetailsViewController () <UITextViewDelegate>

@end

@implementation RecipeDetailsViewController

//Synthesize for getters/setters
@synthesize nameLabel, ingredientsTV, instructionsTV;
@synthesize passedObject, passedName, passedType, passedIngredients, passedInstructions, passedObjectID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set textviews with passed data
    nameLabel.text = passedName;
    ingredientsTV.text = passedIngredients;
    instructionsTV.text = passedInstructions;
    
    //Set rounded corners on ing and inst textviews
    [[ingredientsTV layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[ingredientsTV layer] setBorderWidth:0.5];
    [[ingredientsTV layer] setCornerRadius:7.5];
    
    [[instructionsTV layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[instructionsTV layer] setBorderWidth:0.5];
    [[instructionsTV layer] setCornerRadius:7.5];
    
    //Grab string and change to NSAttributedString
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:passedInstructions];
    NSArray *words=[self.instructionsTV.text componentsSeparatedByString:@"\n"];
    //Add url attribute to lines that start with Timer:
    for (NSString *word in words) {
        if ([word hasPrefix:@"Timer:"]) {
            NSRange range=[self.instructionsTV.text rangeOfString:word];
            //Add URL attribute. This is captured later to trigger Timer code
            [string addAttribute:NSLinkAttributeName value:@"Timer://timer" range:range];
        }
    }
    [self.instructionsTV setAttributedText:string];
    
    [ingredientsTV flashScrollIndicators];
    [instructionsTV flashScrollIndicators];
    
    //Override link color
    instructionsTV.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)shareClicked:(id)sender {
    NSString *titleString = @"Share Recipe";
    NSString *alertMessage = @"Recipe would have been shared via social networks, however this feature is not functional yet";
    [self showAlert:alertMessage withTitle:titleString];
    
    NSString *testIngString = ingredientsTV.text;
    NSLog(@"Ing test = %@", testIngString);
    
    instructionsTV.text = testIngString;
}

//Method to create and show alert view if there is no internet connectivity
-(void)showAlert:(NSString *)alertMessage withTitle:(NSString *)titleString {
    UIAlertView *copyAlert = [[UIAlertView alloc] initWithTitle:titleString message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //Show alert
    [copyAlert show];
} //showAlert close

//Method to create and show alert view if there is no internet connectivity
-(void)showTimerAlert:(NSString *)alertMessage {
//    UIAlertView *timerAlert = [[UIAlertView alloc] initWithTitle:titleString message:alertMessage delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//    //Show alert
//    [timerAlert show];
    
    NSString *formattedString = [NSString stringWithFormat:@"%@ \nPlease enter a discription for timer", alertMessage];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start Timer"
                                                    message:formattedString
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Start", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
} //showAlert close

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Edit"]) {
        //Get VC and set items for passed object
        NewRecipeViewController *newRecipeVC = segue.destinationViewController;
        newRecipeVC.passedName = passedName;
        newRecipeVC.passedType = passedType;
        newRecipeVC.passedIngredients = passedIngredients;
        newRecipeVC.passedInstructions = passedInstructions;
        newRecipeVC.passedObjectID = passedObjectID;
        newRecipeVC.passedObject = passedObject;
        
        newRecipeVC.recipeDetailsVC = self;
    }
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSString *rangeString = [textView.text substringWithRange:characterRange];
    NSLog(@"%@", rangeString);
    
    [self showTimerAlert:rangeString];
    
//    //NSString *username = [URL host];
//    
//    //NSLog(@"%@", username);
//    
//    if ([[URL scheme] isEqualToString:@"Timer:"]) {
//        //NSString *username = [URL host];
//        
//        //NSLog(@"==%@", username);
//        // do something with this username
//        // ...
//        return NO;
//    }
    
    return NO;
}

@end
