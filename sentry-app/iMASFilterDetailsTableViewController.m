//
//  iMASFilterDetailsTableViewController.m
//  sentry-app
//
//  Created by Ren, Alice on 7/30/14.
//  Copyright (c) 2014 MITRE Corp. All rights reserved.
//

#import "iMASFilterDetailsTableViewController.h"

@interface iMASFilterDetailsTableViewController ()

@end

@implementation iMASFilterDetailsTableViewController

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
    
    self.list = [self.filterDict objectForKey:@"Terms"];
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return 4;
    return [[self.filterDict objectForKey:@"Terms"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Filter Information";
            break;
        case 1:
            sectionName = @"Filter Terms";
            break;
        default:
            sectionName = nil;
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"FilterDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *filterDict = [NSDictionary dictionaryWithDictionary:self.filterDict];//[self.filter getFilterdict];
    // Configure the cell...
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Filter Name";
            cell.detailTextLabel.text = [filterDict objectForKey:@"Filter name"];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Filter Type";
            cell.detailTextLabel.text = [filterDict objectForKey:@"Filter type"];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Information Type";
            cell.detailTextLabel.text = [filterDict objectForKey:@"Info type"];
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Field to search";
            cell.detailTextLabel.text = [filterDict objectForKey:@"Field"];
        }
    } else {
        // load black/whitelist terms
        cell.textLabel.text = [[filterDict objectForKey:@"Terms"] objectAtIndex:(indexPath.row)];
        cell.detailTextLabel.text = nil;
    }
    
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
