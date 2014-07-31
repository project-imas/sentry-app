//
//  iMASSecurityCheckTableViewController.h
//  sentry-app
//
//  Created by Ren, Alice on 7/30/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iMASSecurityCheckTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *dbgCheckSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *jailbreakCheckSwitch;

@end
