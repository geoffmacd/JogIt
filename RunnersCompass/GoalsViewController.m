//
//  GoalsViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "GoalsViewController.h"
#import "CreateGoalViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GoalsViewController ()

@end

@implementation GoalsViewController

@synthesize table;
@synthesize goalButton;
@synthesize doneBut;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set rounded corners on buttons
    
    //set rounded corners on buttons
    [doneBut.layer setCornerRadius:8.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return number of  goals
    return 4;
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"cell%i%i", indexPath.section, indexPath.row];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 44.0;
    
    
    
}


#pragma mark - UI actions


- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)goalTapped:(id)sender {
    
    CreateGoalViewController  * vc = [[CreateGoalViewController alloc] initWithNibName:@"CreateGoalViewController" bundle:nil];
    
    [self presentViewController:vc animated:true completion:nil];
    
}
@end
