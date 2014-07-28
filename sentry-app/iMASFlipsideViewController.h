//
//  iMASFlipsideViewController.h
//  APSampleApp
//
//  Created by Ganley, Gregg on 8/22/13.
//  Copyright (c) 2013 MITRE Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iMASFlipsideViewController;

@protocol iMASFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(iMASFlipsideViewController *)controller;
@end

@interface iMASFlipsideViewController : UIViewController

@property (weak, nonatomic) id <iMASFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
