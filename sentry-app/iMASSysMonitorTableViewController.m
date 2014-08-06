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

@interface iMASSysMonitorTableViewController ()

//@property NSMutableArray *filters;

@end

@implementation iMASSysMonitorTableViewController

- (IBAction)unwindToSysMonitorScreen:(UIStoryboardSegue *)segue {
    
}

- (void)loadInitialData {
    /*
    Filter *filter1 = [[Filter alloc] initWithOptions:@"Social Media" info:@"Connection Info" type:@"blacklist" field:@"foreign address" list:[NSArray arrayWithObjects:@"facebook",@"twitter",nil]];
    [self.filters addObject:filter1];
    
    Filter *filter2 = [[Filter alloc] initWithOptions:@"sample cat filter" info:@"Connection Info" type:@"whitelist" field:@"foreign address" list:[NSArray arrayWithObject:@"cat"]];
    [self.filters addObject:filter2];
     */
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"filters.plist"];
    
    self.filters = [[NSMutableArray alloc] initWithContentsOfFile:path];
//    NSLog(@"filters array: %@",self.filters);
//    [self.filters writeToFile:path atomically:YES]; // TODO: LOAD FROM FILE INSTEAD OF OVERWRITING
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filters = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
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
        
    // Configure the cell...
    Filter *newFilter = [self.filters objectAtIndex:indexPath.row];
    NSString *nameString = newFilter.filterName;
    cell.textLabel.text = newFilter.filterName;
    cell.detailTextLabel.text = [newFilter.filterType capitalizedString];
    
    return cell;
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowFilterDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        iMASFilterDetailsTableViewController *destViewController = segue.destinationViewController;
        destViewController.filter = [self.filters objectAtIndex:indexPath.row];
    }
}

@end
