//
//  iMASNewFilterTableViewController.m
//  sentry-app
//
//  Created by Ren, Alice on 7/31/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import "iMASNewFilterTableViewController.h"
#import "iMASSysMonitorTableViewController.h"
#import <SecureFoundation.h>
#import "constants.h"

#define fieldPickerIndex 1
#define fieldPickerCellHeight 88

@interface iMASNewFilterTableViewController () {
    NSArray *_fieldPickerData;
    NSArray *_connectionInfoData;
    NSArray *_processInfoData;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIPickerView *fieldPicker;

@property (weak, nonatomic) IBOutlet UITextField *filterNameTextField;

@property (weak, nonatomic) IBOutlet UILabel *fieldLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *fieldPickerCell;
@property BOOL fieldPickerIsShowing;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSMutableArray *termTextFieldsArray;
@property NSMutableArray *tagArray;
@property int termTag;

@end

@implementation iMASNewFilterTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize filter object
    [self initializeFilterObj];
    
    // initialize field picker data choices
    [self loadPickerData];
    
    // set picker delegate/source
    self.fieldPicker.dataSource = self;
    self.fieldPicker.delegate = self;
    
    [self signUpForKeyboardNotifications];
    
    self.filterNameTextField.delegate = self;
    
    self.termTextFieldsArray = [self.termTextFieldsArray mutableCopy];
    
    _tagArray = [[NSMutableArray alloc] init];
    _termTag = 1;
}

- (void) loadPickerData {
    _connectionInfoData = [[NSArray alloc] initWithObjects:FOREIGN_PORT, FOREIGN_ADDRESS, LOCAL_PORT, LOCAL_ADDRESS, nil];
    _processInfoData = [[NSArray alloc] initWithObjects:PROCESS_ID, PROCESS_NAME, PROCESS_USER, nil];
    // default: connection info
    _fieldPickerData = [NSArray arrayWithArray:_connectionInfoData];
}

- (void) initializeFilterObj {
    // initialize to default settings
    self.filter = [[Filter alloc] initWithOptions:@"" info:CONNECTION_INFO type:BLACKLIST field:FOREIGN_ADDRESS list:@[@""]];
}

- (void)viewDidAppear:(BOOL)animated {
    int defaultFieldIndex = 1;
    self.fieldLabel.text = _fieldPickerData[defaultFieldIndex];
    [self.fieldPicker selectRow:defaultFieldIndex inComponent:0 animated:YES];
    
    [self.tableView setEditing:YES animated:YES];
}

- (void)signUpForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow {
    if (self.fieldPickerIsShowing){
        [self hideFieldPickerCell];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.filterNameTextField) {
        if (textField.text)
            self.filter.filterName = textField.text;
    }
    
    if ([_termTextFieldsArray indexOfObject:textField] != NSNotFound && textField.tag > 0) {
        if (textField.text) {
            UITableViewCell *textFieldRowCell;
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                // Load resources for iOS 6.1 or earlier
                textFieldRowCell = (UITableViewCell *) textField.superview.superview;
            } else {
                // Load resources for iOS 7 or later
                textFieldRowCell = (UITableViewCell *) textField.superview.superview.superview;
            }
            NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldRowCell];
            if ([self.filter.termList count] > indexPath.row)
                [self.filter.termList replaceObjectAtIndex:indexPath.row withObject:textField.text];
            else
                [self.filter.termList insertObject:textField.text atIndex:indexPath.row];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (section == 4)
        return [self.filter.termList count];
    else
        return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // for cells not in terms section, rely on the IB definition of the cell
    if (indexPath.section != 4)
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // configure term cell
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"FilterTermCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterTermCell"];
        
        if (indexPath.row == self.filter.termList.count-1) {
            cell.textLabel.text = @"Add new term";
            return cell;
        }
        
        if ([self.filter.termList indexOfObject:@""] != NSNotFound) {
            UITextField *termTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, cell.contentView.frame.size.width-15, 30)];
            termTextField.adjustsFontSizeToFitWidth = YES;
            termTextField.placeholder = @"New filter term";
            termTextField.keyboardType = UIKeyboardTypeDefault;
            termTextField.returnKeyType = UIReturnKeyDone;
            termTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            termTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            termTextField.delegate = self;
            termTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [termTextField setEnabled:YES];
            termTextField.tag = _termTag;
            if ([_tagArray count] > indexPath.row)
                [_tagArray insertObject:[NSNumber numberWithInteger:_termTag] atIndex:indexPath.row];
            else
                [_tagArray addObject:[NSNumber numberWithInteger:_termTag]];
            _termTag++;
            
            [cell.contentView addSubview:termTextField];
            [_termTextFieldsArray addObject:termTextField];
        }
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 4)
        return NO;
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ([self.filter.termList count]-1))
        return UITableViewCellEditingStyleInsert;
    else
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.filter.termList removeObjectAtIndex:indexPath.row];
        
        // test
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        int tag = [[_tagArray objectAtIndex:indexPath.row] intValue];
        UITextField *tf = (UITextField *)[cell viewWithTag:tag];
        if (tf)
            tf.text = @"";
        [_tagArray removeObjectAtIndex:indexPath.row];
        [_tagArray addObject:[NSNumber numberWithInt:tag]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // add a new cell
        [self.filter.termList insertObject:@"" atIndex:[self.filter.termList count]];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /* filter type (blacklist/whitelist) */
    if (indexPath.section == 1) {
        // show/hide checkmark
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        NSInteger unselectedRow = 1-indexPath.row;
        NSIndexPath *otherCellIndexPath = [NSIndexPath indexPathForRow:unselectedRow inSection:1];
        [[tableView cellForRowAtIndexPath:otherCellIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
        
        // store preference
        if (indexPath.row == 0)
            self.filter.filterType = BLACKLIST;
        else
            self.filter.filterType = WHITELIST;
    }
    
    /* information type (connection/process) */
    if (indexPath.section == 2) {
        // show/hide checkmark
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        NSInteger unselectedRow = 1-indexPath.row;
        NSIndexPath *otherCellIndexPath = [NSIndexPath indexPathForRow:unselectedRow inSection:2];
        [[tableView cellForRowAtIndexPath:otherCellIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
        
        // store preference
        if (indexPath.row == 0) {
            self.filter.infoType = CONNECTION_INFO;
            _fieldPickerData = [NSArray arrayWithArray:_connectionInfoData];
        }
        else {
            self.filter.infoType = PROCESS_INFO;
            _fieldPickerData = [NSArray arrayWithArray:_processInfoData];
        }
        self.fieldLabel.text = _fieldPickerData[indexPath.row];
        self.filter.field = _fieldPickerData[indexPath.row];
        [self.fieldPicker reloadAllComponents];
    }
    
    /* inline field picker */
    if (indexPath.section == 3 && indexPath.row == 0){
        if (self.fieldPickerIsShowing)
            [self hideFieldPickerCell];
        else
            [self showFieldPickerCell];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showFieldPickerCell {
    [self.filterNameTextField resignFirstResponder];
    for (UITextField *txtfld in _termTextFieldsArray) {
        [txtfld resignFirstResponder];
    }
    
    self.fieldPickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.fieldPicker.hidden = NO;
    self.fieldPicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.fieldPicker.alpha = 1.0f;
    }];
}

- (void)hideFieldPickerCell {
    self.fieldPickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.fieldPicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.fieldPicker.hidden = YES;
                     }];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _fieldPickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _fieldPickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.fieldLabel.text = _fieldPickerData[row];
    self.filter.field = _fieldPickerData[row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.tableView.rowHeight;
    if (indexPath.section == 3 && indexPath.row == fieldPickerIndex)
        height = self.fieldPickerIsShowing ? fieldPickerCellHeight : 0.0f;
    return height;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (sender == self.doneButton) {
        /* remove blank terms from array */
        [self.filter.termList removeObject:@"" inRange:NSMakeRange(0, self.filter.termList.count)];
        
        /* input check: there should be at least 1 term and a filter name */
        if ([self.filter.filterName isEqualToString:@""]) {
            [self.filter.termList addObject:@""];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Error"
                                                            message:@"Please enter a filter name."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        if (self.filter.termList.count == 0) {
            [self.filter.termList addObject:@""];
            [[[UIAlertView alloc] initWithTitle:@"Input Error"
                                        message:@"Please enter at least one term to filter."
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil]
             show];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (sender != self.doneButton) return;
    

    NSMutableArray *filtersArray = [iMASFilterClass loadFilters];
    NSDictionary *newFilterDict = self.filter.getFilterdict;
    [filtersArray addObject:newFilterDict];
    
    [iMASFilterClass writeFilters:filtersArray];
    
    iMASSysMonitorTableViewController *destViewController = segue.destinationViewController;
    destViewController.filters = filtersArray;
}


/* ===================================================
 * override methods to implement dynamic cells in static table
 * =================================================== */
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = (int)indexPath.section;
    // if dynamic section, make all rows the same indentation level as row 0
    if (section == 4) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [super tableView:tableView titleForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [super tableView:tableView heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [super tableView:tableView viewForHeaderInSection:section];
}

@end
