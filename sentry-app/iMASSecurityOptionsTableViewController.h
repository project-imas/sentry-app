//
//  iMASSecurityOptionsTableViewController.h
//  sentry-app
//
//  Created by Hostyk, Joe on 8/19/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iMASSecurityOptionsTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *notificationsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *exitAppSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *reportToMDMSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *geofencingSwitch;
@property (weak, nonatomic) IBOutlet UITextField *MDM_URLField;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (weak, nonatomic) IBOutlet UITextField *radius;


@end
