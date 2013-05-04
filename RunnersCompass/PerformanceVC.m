//
//  CreateGoalViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "PerformanceVC.h"
#import "ChartCell.h"
#import "PredictorVC.h"
#import <QuartzCore/QuartzCore.h>


@implementation PerformanceVC

@synthesize table,header, weekly, analysis, prefs;

-(void)viewDidAppear:(BOOL)animated
{
    if(showPurchaseNotification)
    {
        //present notification and thank you
        //present PR notification popup
        StandardNotifyVC * vc = [[StandardNotifyVC alloc] initWithNibName:@"StandardNotify" bundle:nil];
        [vc.view setBackgroundColor:[Util redColour]];
        [vc.view.layer setCornerRadius:5.0f];
        [vc.titleLabel setText:NSLocalizedString(@"thankyou","thank you on notification label")];
        [vc.updateLabel setText:NSLocalizedString(@"AppUpdated","description on notification label")];
        
        [self presentPopupViewController:vc animationType:MJPopupViewAnimationSlideTopBottom];
        
        showPurchaseNotification = false;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //initially on weekly view, more popular methinks
    weekly = false;
    
    //add cells to views
    cells = [[NSMutableArray alloc] initWithCapacity:MetricTypeActivityCount];
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
#pragma mark UpgradeVC Delegate

-(void)didPurchase
{
    prefs.purchased = [NSNumber numberWithBool:true];
    showPurchaseNotification = true;
}

#pragma mark -
#pragma mark Performance Table data source


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0 || tableView != table)
        return nil;
    
    //deliver goalheadercell
    if(!header)
    {
        header = (PermHeaderCell*) [[[NSBundle mainBundle]loadNibNamed:@"PermHeaderCell"
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
        header =  (PermHeaderCell*) [[[NSBundle mainBundle]loadNibNamed:@"PermHeaderCell"
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
    //return number of charts
    return MetricTypeClimbed + 1; //for pr cell
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    //PR cell
    if(row == 0)
    {
        if(!prCell)
        {
            prCell  =  [[[NSBundle mainBundle]loadNibNamed:@"PRCell"owner:self options:nil] objectAtIndex:0];
            
            [prCell setDelegate:self];
            [prCell setPrefs:prefs];
            
            NSString * fastestString = @"---";
            RunEvent * fastestRun = [analysis fastestRun];
            if(fastestRun)
                fastestString = [RunEvent getPaceString:fastestRun.avgPace withMetric:[prefs.metric boolValue] showSpeed:[prefs.showSpeed boolValue]];
            
            NSString * furthestString = @"---";
            RunEvent * furthestRun = [analysis furthestRun];
            if(furthestRun)
                furthestString = [NSString stringWithFormat:@"%.1f",[RunEvent getDisplayDistance:furthestRun.distance  withMetric:[prefs.metric boolValue]] ];
            
            NSString * caloriesString = @"---";
            RunEvent * caloriesRun = [analysis caloriesRun];
            if(caloriesRun)
                caloriesString = [NSString stringWithFormat:@"%.0f",caloriesRun.calories];
            
            NSString * longestString = @"---";
            RunEvent * longestRun = [analysis longestRun];
            if(longestRun)
                longestString = [RunEvent getTimeString:longestRun.time];
            
            [prCell setupWithFastest:fastestString fastDate:fastestRun.date furthest:furthestString furthestDate:furthestRun.date calories:caloriesString calsDate:caloriesRun.date  longest:longestString  longestDate:longestRun.date];
        }
        return prCell;
    }
    
    if(row > [cells count]){
        ChartCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"ChartCell"owner:self options:nil] objectAtIndex:0];
        
        [cells addObject:cell];
        
        [cell setDelegate:self];
        [cell setPrefs:prefs];
        //set data for cells with array at index of the metric
        NSMutableArray * weeklyValuesToSet = [analysis.weeklyMeta objectAtIndex:row-1];
        NSMutableArray * monthlyValuesToSet = [analysis.monthlyMeta objectAtIndex:row-1];
        [cell setWeeklyValues:weeklyValuesToSet];
        [cell setMonthlyValues:monthlyValuesToSet];
        [cell setRaceCell:false];
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
        if(prCell)
            height = [prCell getHeightRequired];
        else
            height = 60;
    }
    else if(row<= [cells count]){
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

- (IBAction)predictTapped:(id)sender {
    
    /*
    PredictorVC * vc = [[PredictorVC alloc] initWithNibName:@"Predictor" bundle:nil];
    
    [vc setAnalysis:analysis];
    [vc setPrefs:prefs];
    
    [self presentViewController:vc animated:true completion:nil];
     
     */
    
    if([prefs.purchased boolValue])
    {
        
        PredictorVC * vc = [[PredictorVC alloc] initWithNibName:@"Predictor" bundle:nil];
        
        [vc setAnalysis:analysis];
        [vc setPrefs:prefs];
        
        [self presentViewController:vc animated:true completion:nil];
    }
    else
    {
        UpgradeVC * vc = [[UpgradeVC alloc] initWithNibName:@"Upgrade" bundle:nil];
        [vc setPrefs:prefs];
        [vc setDelegate:self];
        
        [self presentViewController:vc animated:true completion:nil];
     }
    
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
