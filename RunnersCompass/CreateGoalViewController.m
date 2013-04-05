//
//  CreateGoalViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "CreateGoalViewController.h"
#import "EditGoalViewController.h"
#import "CreateGoalCell.h"
#import "CreateGoalHeaderCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CreateGoalViewController ()

@property (nonatomic, retain) Goal * tempGoal;

@end

@implementation CreateGoalViewController

@synthesize table,header;
@synthesize tempGoal,goal;



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Action sheet delegate methods

-(void)shouldUserDiscardGoal
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"DiscardCurrentGoal", @"Question for discarding goal")//@"Do you want to discard the current goal?"
                                        delegate:self
                               cancelButtonTitle:NSLocalizedString(@"CancelWord", @"cancel word")
                          destructiveButtonTitle:NSLocalizedString(@"DiscardWord", @"discard word")
                               otherButtonTitles:nil];
    
    // Show the sheet in view
    
    [sheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    
    if(buttonIndex == 0)
    {
        //dump old goal, even if user cancels out
        //send notification to app delegate
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"goalChangedNotification"
         object:nil];
        
        //reload table to remove checkmark
        goal.type = GoalTypeNoGoal;
        [table reloadData];
        
        EditGoalViewController  * vc = [[EditGoalViewController alloc] initWithNibName:@"EditGoalViewController" bundle:nil];
        [vc setTempGoal:tempGoal];
        [self presentViewController:vc animated:true completion:nil];
        
    }
    else if(buttonIndex == 1)
    {
        //do nothing
        
    }
}

#pragma mark -
#pragma mark  Table data source

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
    
    CreateGoalCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"CreateGoalCell"
                                                      owner:self
                                                    options:nil]objectAtIndex:0];
    [cell setup:row+1 withCurrentGoalType:goal.type];
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

#pragma mark -
#pragma mark  Table delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    tempGoal = [[Goal alloc] initWithType:[indexPath row]+1];
    Goal * curGoal = goal;
    
    if(curGoal && curGoal.type != GoalTypeNoGoal)
    {
        //only discard if the user is not trying to edit the current goal
        if(curGoal.type != [indexPath row]+1)
        {
            [self shouldUserDiscardGoal];
        }
        else{
            //leave current goal in to be edited
            
            
            EditGoalViewController  * vc = [[EditGoalViewController alloc] initWithNibName:@"EditGoalViewController" bundle:nil];
            [vc setTempGoal:curGoal];
            [self presentViewController:vc animated:true completion:nil];
        }
    }
    else{
        
        EditGoalViewController  * vc = [[EditGoalViewController alloc] initWithNibName:@"EditGoalViewController" bundle:nil];
        [vc setTempGoal:tempGoal];
        [self presentViewController:vc animated:true completion:nil];
    }
    
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0 || tableView != table)
        return nil;
    
    //deliver goalheadercell
    if(!header)
    {
        header = (CreateGoalHeaderCell*) [[[NSBundle mainBundle]loadNibNamed:@"CreateGoalHeaderCell"
                                                                 owner:self
                                                               options:nil]objectAtIndex:0];
        
        //set rounded corners on button
        [header.doneBut.layer setCornerRadius:8.0f];
        [header.doneBut setTitle:NSLocalizedString(@"DoneButton", @"done button") forState:UIControlStateNormal];
        
        [header.doneBut.layer setMasksToBounds:true];
        [header.sectionHeaderCreateGoal setText:NSLocalizedString(@"CreateGoalHeader", @"header to describe create goal")];

    }
    
    return header;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!header)
    {
        header =  (CreateGoalHeaderCell*) [[[NSBundle mainBundle]loadNibNamed:@"CreateGoalHeaderCell"
                                                                  owner:self
                                                                      options:nil]objectAtIndex:0];
        //set rounded corners on button
        [header.doneBut.layer setCornerRadius:8.0f];
        [header.doneBut setTitle:NSLocalizedString(@"DoneButton", @"done button") forState:UIControlStateNormal];
        
        [header.doneBut.layer setMasksToBounds:true];
        [header.sectionHeaderCreateGoal setText:NSLocalizedString(@"CreateGoalHeader", @"header to describe create goal")];
        
        
    }
    
    //return height of header, does not change
    return header.frame.size.height;
    
}

#pragma mark -
#pragma mark  UI Actions

- (IBAction)doneCreateGoalTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
