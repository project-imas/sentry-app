//
//  iMASNewFilterTableViewController.h
//  sentry-app
//
//  Created by Ren, Alice on 7/31/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Filter.h>

@interface iMASNewFilterTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property Filter *filter;

@end
