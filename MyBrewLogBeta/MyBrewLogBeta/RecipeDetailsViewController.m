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
    
    nameLabel.text = passedName;
    ingredientsTV.text = passedIngredients;
    instructionsTV.text = passedInstructions;
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:passedInstructions];
    
    NSArray *words=[self.instructionsTV.text componentsSeparatedByString:@"\n"];
    
    for (NSString *word in words) {
        if ([word hasPrefix:@"Timer:"]) {
            NSRange range=[self.instructionsTV.text rangeOfString:word];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            
            [string addAttribute:NSLinkAttributeName value:@"Timer://timer" range:range];
        }
    }
    [self.instructionsTV setAttributedText:string];
    
    //NSString *testString = @"test line 1 \nline 2 \nline 3 \nline 4 \nend";
    
    [ingredientsTV flashScrollIndicators];
    [instructionsTV flashScrollIndicators];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)textViewDidChange:(UITextView *)textView {
//    NSAttributedString *attrStr = textView.attributedText;
//    NSString * string = [attrStr string];
//    NSRegularExpression* myRegex = NameRegularExpression();
//    NSArray * matches = [myRegex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
//    
//    NSMutableAttributedString *attrMutableStr = [[NSMutableAttributedString alloc] initWithString:string];
//    
//    for (NSTextCheckingResult* match in matches ) {
//        [attrMutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:match.range];
//    }
//    textView.attributedText = attrMutableStr;
//    textView.contentSize = CGSizeMake(textView.frame.size.width, textView.contentSize.height);
//}

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
    
    NSString *formattedString = [NSString stringWithFormat:@"%@ \nPlease enter a discription for the timer", alertMessage];
    
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
    NSLog(@"==%@", rangeString);
    
    [self showTimerAlert:rangeString];
    
    //NSString *username = [URL host];
    
    //NSLog(@"%@", username);
    
    if ([[URL scheme] isEqualToString:@"Timer:"]) {
        //NSString *username = [URL host];
        
        //NSLog(@"==%@", username);
        // do something with this username
        // ...
        return NO;
    }
    
    return NO;
}

@end
