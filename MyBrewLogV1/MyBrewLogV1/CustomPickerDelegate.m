/*NOTE: This is from the ActionSsheetPicker obj-c example project found at https://github.com/skywinder/ActionSheetPicker-3.0/blob/master/ObjC-Example/Example/Classes/ActionSheetPickerViewController.m#L171 and it is in the process of being modified and utilized within my project. The documentation for this open source library isn't great but the coding style is fairly easy to read so I am working it out on my own.*/

//
//  CustomPickerDelegate.m
//  MyBrewLogV1
//
//  Created by Elijah Freestone on 3/26/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "CustomPickerDelegate.h"

@implementation CustomPickerDelegate

- (id)init
{
    if (self = [super init]) {
        measurementArray = [NSArray arrayWithObjects:@"qt", @"cup", @"gal", @"oz", @"lbs", nil];
        ingredientArray = [NSArray arrayWithObjects:@"Ingedient 1", @"Ingedient 2", @"Ingedient 3", @"Ingedient 4", @"Ingedient 5", @"Ingedient 6", @"Other", nil];
    }
    return self;
}
/////////////////////////////////////////////////////////////////////////
#pragma mark - ActionSheetCustomPickerDelegate Optional's
/////////////////////////////////////////////////////////////////////////
- (void)configurePickerView:(UIPickerView *)pickerView
{
    // Override default and hide selection indicator
    pickerView.showsSelectionIndicator = NO;
}
//- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
//{
//    NSString *resultMessage = [NSString stringWithFormat:@"%@ %@ selected.",
//                               self.selectedKey,
//                               self.selectedScale];
//    [[[UIAlertView alloc] initWithTitle:@"Success!" message:resultMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//}
/////////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerViewDataSource Implementation
/////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component) {
        case 0: return [measurementArray count];
        case 1: return [ingredientArray count];
        default:break;
    }
    return 0;
}
/////////////////////////////////////////////////////////////////////////
#pragma mark UIPickerViewDelegate Implementation
/////////////////////////////////////////////////////////////////////////
// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: return 60.0f;
        case 1: return 260.0f;
        default:break;
    }
    return 0;
}
/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
 {
 return
 }
 */
// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: return measurementArray[(NSUInteger) row];
        case 1: return ingredientArray[(NSUInteger) row];
        default:break;
    }
    return nil;
}
/////////////////////////////////////////////////////////////////////////
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Row %li selected in component %li", (long)row, (long)component);
    switch (component) {
        case 0:
            self.selectedMeasurement = measurementArray[(NSUInteger) row];
            return;
        case 1:
            self.selectedIngredient = ingredientArray[(NSUInteger) row];
            return;
        default:break;
    }
}

@end