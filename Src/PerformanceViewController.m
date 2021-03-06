//
//  PerformanceViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "PerformanceViewController.h"
#import "PredictorViewController.h"
#import "DataTest.h"

@implementation PerformanceViewController

@synthesize table;
@synthesize weekly;
@synthesize weeklyBut;
@synthesize monthlyBut;
@synthesize predictBut;
@synthesize doneBut;

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //initially on weekly view, more popular methinks
    weekly = false;
    [self weeklyTapped:nil];
    
    //set rounded corners on buttons
    [predictBut.layer setCornerRadius:8.0f];
    [doneBut.layer setCornerRadius:8.0f];
    
    
    //add ChartViewControllers to views
    cells = [[NSMutableArray alloc] initWithCapacity:10];
    
    analysis = [[DataTest sharedData] analysis];
    
    //localized buttons in IB
    [predictBut setTitle:NSLocalizedString(@"PredictButtonTitle", @"button for prediction view") forState:UIControlStateNormal];
    [weeklyBut setTitle:NSLocalizedString(@"WeeklyButton", @"button for weekly") forState:UIControlStateNormal];
    [monthlyBut setTitle:NSLocalizedString(@"MonthlyButton", @"button for monthly") forState:UIControlStateNormal];
    [doneBut setTitle:NSLocalizedString(@"DoneButton", @"done button") forState:UIControlStateNormal];
    
}



#pragma mark -
#pragma mark Menu Table data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return number of charts
    return MetricTypeStride;
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    
    if(row >= [cells count]){
        ChartCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"ChartCell"
                                                                  owner:self
                                                                options:nil]objectAtIndex:0];
        
        [cells addObject:cell];
        
        [cell setDelegate:self];
        //set data for cells with array at index of the metric
        NSMutableArray * valuesToSet = [analysis.weeklyMeta objectAtIndex:row+1];
        [cell setWeeklyValues:valuesToSet];
        [cell setMonthlyValues:valuesToSet];
        [cell setTimePeriod:weekly];
        //must be last
        [cell setAssociated:row+1];//convert row to runmetric assuming
        
        
        return cell;
    }
    else{
        
        
        ChartCell * curCell = [cells objectAtIndex:row];
        [curCell setTimePeriod:weekly];
        
        return curCell;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    NSUInteger row = [indexPath row];
    if(row< [cells count]){
        ChartCell * cell = [cells objectAtIndex:row];
        
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
}

#pragma mark - other actions

- (IBAction)doneTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)predictTapped:(id)sender {
    PredictorViewController * vc = [[PredictorViewController alloc] initWithNibName:@"Predictor" bundle:nil];
    
    
    [self presentViewController:vc animated:true completion:^{
        
    }];
}

- (IBAction)weeklyTapped:(id)sender {
    if(!weekly)
    {
        UIColor *col1 = [UIColor darkGrayColor];
        UIColor *col2 = [UIColor colorWithRed:192.0f/255 green:24.0f/255 blue:37.0f/255 alpha:1.0f];
        
        [monthlyBut setBackgroundColor:col1];
        [weeklyBut setBackgroundColor:col2];
        
        weekly = true;
        
        //to trigger setWeekly methods
        if(sender)//must of have been manual from viewdidload to prevent unloaded reloadtable
        {
            //[cells removeAllObjects];//remove everything to cause to reload
            [table reloadData];
        }
    }
}

- (IBAction)monthlyTapped:(id)sender {
    if(weekly)
    {
        
        UIColor *col1 = [UIColor darkGrayColor];
        UIColor *col2 = [UIColor colorWithRed:192.0f/255 green:24.0f/255 blue:37.0f/255 alpha:1.0f];
        
        [monthlyBut setBackgroundColor:col2];
        [weeklyBut setBackgroundColor:col1];
        
        weekly = false;
        
        //to trigger setWeekly methods
        if(sender)//must of have been manual from viewdidload to prevent unloaded reloadtable
        {
            //[cells removeAllObjects];//remove everything to cause to reload
            [table reloadData];
        }
    }
}


@end
