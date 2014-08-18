//
//  iMASSysMonitorTableViewController.m
//  sentry-app
//
//  Created by Ren, Alice on 7/30/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import "iMASSysMonitorTableViewController.h"
#import <Filter.h>
#import "iMASFilterDetailsTableViewController.h"
#import <SecureFoundation.h>
#import "constants.h"

@interface iMASSysMonitorTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end

@implementation iMASSysMonitorTableViewController

- (IBAction)unwindToSysMonitorScreen:(UIStoryboardSegue *)segue {

}

- (void)loadInitialData {
    self.filters = [iMASFilterClass loadFilters];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadInitialData];
    [super viewWillAppear:animated];
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
    
    NSDictionary *filterDict = [self.filters objectAtIndex:indexPath.row];
    NSString *nameString = [filterDict objectForKey:FILTER_NAME];
    cell.textLabel.text = nameString;
    NSString *filterTypeString = [[filterDict objectForKey:FILTER_TYPE] capitalizedString];
    NSString *infoTypeString = [filterDict objectForKey:FILTER_INFO_TYPE];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",infoTypeString,filterTypeString];
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        @synchronized(self.filters) {
            [self.filters removeObjectAtIndex:indexPath.row];
            [iMASFilterClass writeFilters:self.filters];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowFilterDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        iMASFilterDetailsTableViewController *destViewController = segue.destinationViewController;
        destViewController.filterDict = [self.filters objectAtIndex:indexPath.row];
    }
}

@end
