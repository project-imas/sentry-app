//
//  iMASSecurityOptionsTableViewController.m
//  sentry-app
//
//  Created by Hostyk, Joe on 8/19/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import "iMASSecurityOptionsTableViewController.h"
#import <SecureFoundation.h>
#import "constants.h"

@interface iMASSecurityOptionsTableViewController ()

@end

@implementation iMASSecurityOptionsTableViewController

// store switches' statuses in the IMSKeychain

- (IBAction)notificationSwitchChanged:(id)sender {
    NSString *notificationSwitchState = [IMSKeychain passwordForService:serviceName account:@"notificationSwitch"];
    if ([sender isOn]) {
        if (![notificationSwitchState isEqualToString:@"ON"]) {
            [IMSKeychain setPassword:@"ON" forService:serviceName account:@"notificationSwitch"];
        }
    } else {
            [IMSKeychain setPassword:@"OFF" forService:serviceName account:@"notificationSwitch"];
    }
}

- (IBAction)exitAppSwitchChanged:(id)sender {
    NSString *exitAppSwitchState = [IMSKeychain passwordForService:serviceName account:@"exitAppSwitch"];
    if ([sender isOn]) {
        if (![exitAppSwitchState isEqualToString:@"ON"]) {
            [IMSKeychain setPassword:@"ON" forService:serviceName account:@"exitAppSwitch"];
        }
    } else {
        [IMSKeychain setPassword:@"OFF" forService:serviceName account:@"exitAppSwitch"];
    }
}

- (IBAction)reportToMDMSwitchChanged:(id)sender {
    NSString *reportToMDMSwitchState = [IMSKeychain passwordForService:serviceName account:@"reportToMDMSwitch"];
    if ([sender isOn]) {
        if (![reportToMDMSwitchState isEqualToString:@"ON"]) {
            [IMSKeychain setPassword:@"ON" forService:serviceName account:@"reportToMDMSwitch"];
            _MDM_URLField.hidden = NO;
        }
    } else {
        [IMSKeychain setPassword:@"OFF" forService:serviceName account:@"reportToMDMSwitch"];
        _MDM_URLField.hidden = YES;
    }
}
- (IBAction)geofencingSwitchChanged:(id)sender {
    NSString *geofencingSwitchState = [IMSKeychain passwordForService:serviceName account:@"geofencingSwitch"];
    if ([sender isOn]) {
        if (![geofencingSwitchState isEqualToString:@"ON"]) {
            [IMSKeychain setPassword:@"ON" forService:serviceName account:@"geofencingSwitch"];
        }
    } else {
        [IMSKeychain setPassword:@"OFF" forService:serviceName account:@"exitAppSwitch"];
    }
}

- (IBAction)enteredLatitude:(id)sender {
    [IMSKeychain setPassword:self.latitude.text forService:serviceName account:@"latitude"];
}

- (IBAction)enteredLongitude:(id)sender {
    [IMSKeychain setPassword:self.longitude.text forService:serviceName account:@"longitude"];
}

- (IBAction)enteredRadius:(id)sender {
    [IMSKeychain setPassword:self.radius.text forService:serviceName account:@"radius"];
}


- (IBAction)enteredMDMURL:(id)sender {
    [IMSKeychain setPassword:self.MDM_URLField.text forService:serviceName account:@"MDMURL"];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set switch to position stored in keychain
    
    NSString *notificationSwitchState = [IMSKeychain passwordForService:serviceName account:@"notificationSwitch"];
    if([notificationSwitchState isEqualToString:@"ON"]){
        [_notificationsSwitch setOn:YES];
    }
    else {
        [_notificationsSwitch setOn:NO];
    }
    
    NSString *exitAppSwitchState = [IMSKeychain passwordForService:serviceName account:@"exitAppSwitch"];
    if([exitAppSwitchState isEqualToString:@"ON"]){
        [_exitAppSwitch setOn:YES];
    }
    else {
        [_exitAppSwitch setOn:NO];
    }
    
    NSString *reportToMDMSwitchState = [IMSKeychain passwordForService:serviceName account:@"reportToMDMSwitch"];
    if([reportToMDMSwitchState isEqualToString:@"ON"]){
        [_reportToMDMSwitch setOn:YES];
    }
    else {
        [_reportToMDMSwitch setOn:NO];
        _MDM_URLField.hidden = YES;
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
