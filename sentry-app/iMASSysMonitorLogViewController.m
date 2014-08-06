//
//  iMASSysMonitorLogViewController.m
//  sentry-app
//
//  Created by Ren, Alice on 8/6/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import "iMASSysMonitorLogViewController.h"

@interface iMASSysMonitorLogViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation iMASSysMonitorLogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // load log from file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
    NSError *error = nil;
    NSString *logString = [NSString stringWithContentsOfFile:logPath encoding:NSUTF8StringEncoding error:&error];
    
    [self.textView setText:logString];//[textView setText:logString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
