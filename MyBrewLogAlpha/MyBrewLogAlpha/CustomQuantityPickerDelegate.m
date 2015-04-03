// Elijah Freestone
// IPY 1504
// Week 1 - Alpha
// March 30th, 2015

//
//  CustomQuantityPickerDelegate.m
//  MyBrewLogAlpha
//
//  Created by Elijah Freestone on 4/2/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "CustomQuantityPickerDelegate.h"

@implementation CustomQuantityPickerDelegate {
    NSArray *measurementArray;
    NSArray *ingredientArray;
    NSMutableArray *amountHundreds;
    NSMutableArray *amountTens;
    NSMutableArray *amountOnes;
    NSString *selectedHundreds;
    NSString *selectedTens;
    NSString *selectedOnes;
    NSString *selectedMeasurement;
    NSString *formattedQuantity;
}


//@property (nonatomic, strong)

//Init and build arrays
- (id)init {
    if (self = [super init]) {
        measurementArray = [NSArray arrayWithObjects:@"qt", @"cup", @"gal", @"oz", @"lbs", nil];
        ingredientArray = [NSArray arrayWithObjects:@"Ingedient 1", @"Ingedient 2", @"Ingedient 3", @"Ingedient 4", @"Ingedient 5", @"Ingedient 6", @"Other", nil];
        amountHundreds = [[NSMutableArray alloc] init];
        amountTens = [[NSMutableArray alloc] init];
        amountOnes = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < 10; i++) {
            NSString *stringVal = [NSString stringWithFormat:@"%d", i];
            [amountHundreds addObject:stringVal];
            [amountTens addObject:stringVal];
            [amountOnes addObject:stringVal];
        }
        
        NSLog(@"meas: %lu", (unsigned long)[measurementArray count]);
        
        //Set defaults of picker selections
        selectedHundreds = @"0";
        selectedTens = @"0";
        selectedOnes = @"0";
        selectedMeasurement = measurementArray[0];
        
    }
    return self;
}

#pragma mark - UIPickerViewDataSource Implementation

//Set number of components
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

//Set number of rows
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //Returns
    switch (component) {
        case 0:
//            return 10;
            return [amountHundreds count];
        case 1:
            return [amountTens count];
        case 2:
            return [amountOnes count];
        case 3:
            return [measurementArray count];
        default:break;
    }
    return 0;
}

#pragma mark UIPickerViewDelegate Implementation

//Returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return 30.0f;
        case 1:
            return 30.0f;
        case 2:
            return 30.0f;
        case 3:
            return 200.0f;
        default:break;
    }
    return 0;
}

//Set content for components
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return amountHundreds[(NSUInteger) row];
        case 1:
            return amountTens[(NSUInteger) row];
        case 2:
            return amountOnes[(NSUInteger) row];
        case 3:
            return measurementArray[(NSUInteger) row];
        default:break;
    }
    return nil;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    NSString *resultMessage;
    if (!selectedOnes && !selectedMeasurement)
    {
        resultMessage = [NSString stringWithFormat:@"Nothing is selected, inital selections: %@ %@", selectedOnes, selectedMeasurement];
        
        //selectedHundreds[(NSUInteger) [(UIPickerView *) actionSheetPicker.pickerView selectedRowInComponent:0]]
        
    } else {
        resultMessage = formattedQuantity;
    }
    
    [self.myRecipeVC quantityPicked:resultMessage];
    
    [[[UIAlertView alloc] initWithTitle:@"Success!" message:resultMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
//    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self.delegate
//                                   selector:@selector(quantityPicked:) userInfo:nil repeats:NO];
}

//Grab selections
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Row %li selected in component %li", (long)row, (long)component);
    
    if (component == 0) {
        selectedHundreds = amountHundreds[row];
    }
    if (component == 1) {
        selectedTens = amountTens[row];
    }
    if (component == 2) {
        selectedOnes = amountOnes[row];
    }
    if (component == 3) {
        selectedMeasurement = measurementArray[row];
    }
    
//    switch (component) {
//        case 0:
//            selectedHundreds = amountHundreds[row];
//            return;
//        case 1:
//            selectedTens = amountTens[row];
//            return;
//        case 2:
//            selectedOnes = amountOnes[row];
//            return;
//        case 3:
//            selectedMeasurement = measurementArray[row];
////            return;
//        default:break;
//    }
    
    formattedQuantity = [NSString stringWithFormat:@"%@%@%@ %@", selectedHundreds, selectedTens, selectedOnes, selectedMeasurement];
    NSLog(@"formatted # = %@", formattedQuantity);
    
}

@end
