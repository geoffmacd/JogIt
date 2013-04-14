//
//  CreateGoalViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "PredictorVC.h"
#import "ChartCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PredictorVC

@synthesize table,header, weekly, analysis, prefs;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //initially on weekly view, more popular methinks
    weekly = false;
    
    //add ChartViewControllers to views
    cells = [[NSMutableArray alloc] initWithCapacity:5];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark -
#pragma mark predict Table data source


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0 || tableView != table)
        return nil;
    
    //deliver goalheadercell
    if(!header)
    {
        header = (PredictHeaderCell*) [[[NSBundle mainBundle]loadNibNamed:@"PredictHeaderCell"
                                                                       owner:self
                                                                     options:nil]objectAtIndex:0];
        
        //round corners
        [header setup];
        [self weeklyTapped:nil];
    }
    
    return header;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!header)
    {
        header =  (PredictHeaderCell*) [[[NSBundle mainBundle]loadNibNamed:@"PredictHeaderCell"
                                                                        owner:self
                                                                      options:nil]objectAtIndex:0];
        //round corners
        [header setup];
        [self weeklyTapped:nil];
        
    }
    
    //return height of header, does not change
    return header.frame.size.height;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (RaceTypeFullMarathon + 1); //+1 for rule cell
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    //rules cell
    if(row == 0)
    {
        if(!ruleCell)
        {
            ruleCell  =  [[[NSBundle mainBundle]loadNibNamed:@"RuleCell"owner:self options:nil] objectAtIndex:0];
            
            [ruleCell setDelegate:self];
            [ruleCell setup];
        }
        return ruleCell;
    }
    
    if(row > [cells count]){
        ChartCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"ChartCell"owner:self options:nil] objectAtIndex:0];
        
        [cells addObject:cell];
        
        [cell setDelegate:self];
        [cell setPrefs:prefs];
        //set data for cells with array at index of the metric
        NSMutableArray * weeklyValuesToSet = [analysis.weeklyRace objectAtIndex:row-1];
        NSMutableArray * monthlyValuesToSet = [analysis.monthlyRace objectAtIndex:row-1];
        [cell setWeeklyValues:weeklyValuesToSet];
        [cell setMonthlyValues:monthlyValuesToSet];
        [cell setRaceCell:true];
        [cell setAssociated:row];//convert row to runmetric assuming
        [cell setTimePeriod:weekly];
        
        return cell;
    }
    else{
        
        
        ChartCell * curCell = [cells objectAtIndex:row-1];
        [curCell setTimePeriod:weekly];
        
        return curCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    NSUInteger row = [indexPath row];
    
    if(row == 0)
    {
        if(ruleCell)
            height = [ruleCell getHeightRequired];
        else
            height = 60;
    }
    else if(row <= [cells count])
    {
        ChartCell * cell = [cells objectAtIndex:row-1];
        
        height = [cell getHeightRequired];
    }
    else{
        height = 48.0f;
    }
    
    NSAssert(height > 40.0, @"invalid cell height");
    
    return height;
}


#pragma mark -  ChartCellDelegate

-(void) cellDidChangeHeight:(id) sender
{
    //animate with row belows move down nicely
    [table beginUpdates];
    [table endUpdates];
    [table reloadData];
    
    //still need to animate hidden expandedView
    
    //if sender was last cell or second last, then scroll to show expanded view
    if(sender == [cells lastObject])
    {
        NSIndexPath *path = [table indexPathForCell:sender];
        [table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:true];
    }
    if([cells count] >= 2)
    {
        if([cells objectAtIndex:[cells count]-2])
        {
            NSIndexPath *path = [table indexPathForCell:sender];
            [table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:true];
        }
    }
}

#pragma mark -
#pragma mark  UI Actions

- (IBAction)doneTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)weeklyTapped:(id)sender {
    if(!weekly)
    {
        UIColor *col1 = [UIColor darkGrayColor];
        UIColor *col2 = [Util redColour];
        
        [header.monthlyBut setBackgroundColor:col1];
        [header.weeklyBut setBackgroundColor:col2];
        
        weekly = true;
        
        //to trigger setWeekly methods
        if(sender)//must of have been manual from viewdidload to prevent unloaded reloadtable
        {
            [table reloadData];
        }
    }
}

- (IBAction)monthlyTapped:(id)sender {
    if(weekly)
    {
        
        UIColor *col1 = [UIColor darkGrayColor];
        UIColor *col2 = [Util redColour];
        
        [header.monthlyBut  setBackgroundColor:col2];
        [header.weeklyBut setBackgroundColor:col1];
        
        weekly = false;
        
        //to trigger setWeekly methods
        if(sender)//must of have been manual from viewdidload to prevent unloaded reloadtable
        {
            [table reloadData];
        }
    }
}

@end
