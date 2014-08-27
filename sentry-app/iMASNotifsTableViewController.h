//
//  iMASNotifsTableViewController.h
//  sentry-app
//
//  Created by Ren, Alice on 8/15/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iMASNotifsTableViewController : UITableViewController

+(void)insertToNotifs:(NSString *)newNotif shouldCrash:(BOOL)crash;

@end
