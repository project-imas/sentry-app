//
//  iMASMainViewController.h
//  APSampleApp
//
//  Created by Ganley, Gregg on 8/22/13.
//  Copyright (c) 2013 MITRE Corp. All rights reserved.
//

#import "iMASFlipsideViewController.h"

#import <CoreData/CoreData.h>

@interface iMASMainViewController : UIViewController <iMASFlipsideViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
