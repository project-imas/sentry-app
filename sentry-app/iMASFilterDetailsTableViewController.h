//
//  iMASFilterDetailsTableViewController.h
//  sentry-app
//
//  Created by Ren, Alice on 7/30/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Filter.h>

@interface iMASFilterDetailsTableViewController : UITableViewController

@property Filter *filter;
@property NSArray *list;

@end
