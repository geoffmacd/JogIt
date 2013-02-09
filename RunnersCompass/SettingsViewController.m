//
//  Settings.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "SettingsViewController.h"
#import "EditTableCell.h"

@interface SettingsViewController()

@end

@implementation SettingsViewController

@synthesize tmpCell,cellNib,table,datePicker;

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

    NSDate *now = [NSDate date];
	[datePicker setDate:now animated:YES];
    
	cellNib = [UINib nibWithNibName:@"EditTableCell" bundle:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section)
    {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 2;
        case 3:
            return 2;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if(section == 0)
    {
        
        UITableViewCell * cell;
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ButtonTableCell" owner:self options:nil];
    	cell = (UITableViewCell *)[nib objectAtIndex:0];
        
        return cell;
    }
    else if(section == 1)
    {
        if(row == 0)
        {   //full name
            EditTableCell * cell;
            
            [self.cellNib instantiateWithOwner:self options:nil];
            cell = tmpCell;
            self.tmpCell = nil;
            
            cell.cusField.text = @"geoff";
            cell.cusLabel.text = @"ds";
            
            return cell;
        }
        else if(row == 1)
        {   //birthdate
            UITableViewCell * cell;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"datecell"];
            
            cell.textLabel.text = @"Birthdate";
            cell.detailTextLabel.text = [[NSDate date] description];
            
            
            return cell;
        }
        
    }
    
    
    
    
    return nil;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    
    [headerView addSubview:label];
    return headerView;
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
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if(section == 0)
    {
        [self dismissViewControllerAnimated:true completion:nil];
    }
    else if(section == 1)
    {
        if(row == 1)
        {
            //date picker show
            
            DatePickViewController * vc = [[DatePickViewController alloc] initWithNibName:@"DatePickViewController" bundle:nil];
            
            vc.modalTransitionStyle = UIModalPresentationPageSheet;
            
            [self presentViewController:vc animated:true completion:nil];
        }
    }
    
    
    
}
#pragma mark - date picker delegate

-(void)finishedWithDate:(NSDate *) date
{
    //update date
    [table reloadData];
    
    
}



#pragma mark - submission forms
- (IBAction)changedDate:(id)sender {
    
    
}
@end
