//
//  MenuViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import "Menu.h"
#import "Constants.h"
#import "RunEvent.h"
#import "Logger.h"
#import "JSSlidingViewController.h"
#import "PerformanceViewController.h"
#import "SettingsViewController.h"
#import "GoalsViewController.h"
#import "CreateGoalViewController.h"
#import "RunFormPicker.h"


@implementation MenuViewController

@synthesize MenuTable;
@synthesize runInProgressAsFarAsICanTell;



#pragma mark -
#pragma mark View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	core = [DataTest sharedData];
    
    if(!start)
    {
        StartCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"StartCell"
                                                           owner:self
                                                         options:nil]objectAtIndex:0];
        [cell setup];
        [cell setDelegate:self];
        
        start = cell;
    }
    
    
    runs = [[NSMutableArray alloc] initWithCapacity:3];
    cells = [[NSMutableArray alloc] initWithCapacity:3];
    
    RunMap * map = [RunMap alloc];

    
    [map setThumbnail:[UIImage imageNamed:@"map.JPG"]];
    
    for(NSInteger i=0;i <12; i++)
    {
        
        RunEvent * run = [[RunEvent alloc] initWithName:@"10.5 Km" date:[NSDate date]];
        
        [run setLive:false];
        
        [run setMap:map];
        
        [runs addObject:run];
        
    }
    
    
    runInProgressAsFarAsICanTell = false;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Menu Table data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    CGFloat height = [start getHeightRequired];
    
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(!start)
        {
            StartCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"StartCell"
                                                               owner:self
                                                             options:nil]objectAtIndex:0];
            [cell setup];
            [cell setDelegate:self];
            
            start = cell;
        }
        
        return start;
        
    }
    
    return nil;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return number of historic runs 
    return [runs count];
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    

    if(row >= [cells count]){
        HierarchicalCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"HierarchicalCell"
                                                 owner:self
                                               options:nil]objectAtIndex:0];
        [cell setAssociated:[runs objectAtIndex:row]];
        [cell setDelegate:self];
        
        [cells addObject:cell];
        
        return cell;
    }
    else{
        
        
        HierarchicalCell * curCell = [cells objectAtIndex:row];
        
        return curCell;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    NSUInteger row = [indexPath row];
    if(row< [cells count]){
        HierarchicalCell * cell = [cells objectAtIndex:row];
    
        height = [cell getHeightRequired];
    }
    else{
        height = 48.0f;
    }
    
    
    return height;
    
}



#pragma mark -
#pragma mark Menu Table delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSUInteger row = [indexPath row];
    
    if(row > ([cells count]) || row == 0)
        return;
    
    
    HierarchicalCell * cell = [cells objectAtIndex:row];
    
    if(!cell.expanded)
    {
        [cell setExpand:true withAnimation:true];
        
        if(row == [cells count])
        {
            //scroll view to see rest of cell below
            [MenuTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:true];
        }
    }
    
}


#pragma mark -
#pragma mark HierarchicalCellDelegate

-(void) cellDidChangeHeight:(id) sender
{
    //animate with row belows move down nicely
    [MenuTable beginUpdates];
    [MenuTable endUpdates];
    [MenuTable reloadData];//needed to have user interaction on start cell if this is expanded, also removes white line issue
    
    
    //still need to animate hidden expandedView
    
    //if sender was last cell or second last, then scroll to show expanded view
    if(sender == [cells lastObject] || [cells objectAtIndex:([cells count] - 2)])
    {
        NSIndexPath *path = [MenuTable indexPathForCell:sender];
        [MenuTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:true];
    }
}


#pragma mark -
#pragma mark Start Cell Delegate

-(void)selectedRunInProgress
{
    //selected the headerview of start cell when run is in progress, slide back to logger
    [self.delegate selectedRunInProgress];
    
}

-(void)selectedNewRun:(RunEvent *) run
{
    //set logger with this run
    [self.delegate newRun:0 withMetric:0 animate:true];
    
    runInProgressAsFarAsICanTell = true;
    
    start.headerLabel.text = @"Run In Progress";
    [start setExpand:false withAnimation:true];
    start.locked = true;//to prevent expanding
    //[start.addRunImage setHidden:true];
    [start.addRunButton setImage:[UIImage imageNamed:@"garbagecan.png"] forState:UIControlStateNormal];
    [start.folderImage setHidden:true];
    
}




#pragma mark -
#pragma mark Logger Interface

-(void)selectedRun:(id)sender
{
    
    HierarchicalCell * cell = (HierarchicalCell * )sender;
    
    //set logger with this run
    [self.delegate loadRun:cell.associatedRun close:true];
    
}

-(void) finishedRun:(RunEvent*)run
{
    
    //save run and add it to the menu if it exists
    
    if(run)
    {
        //must be at 0th index to be at top and reload correctly
        [runs insertObject:run atIndex:0];
        HierarchicalCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"HierarchicalCell" owner:self options:nil]objectAtIndex:0];
        [cell setAssociated:run];
        [cell setDelegate:self];
        [cells insertObject:cell atIndex:0];
        //reload table
        [MenuTable reloadData];
    }
    
    
    //refresh start cell
    
    runInProgressAsFarAsICanTell = false;
    start.headerLabel.text = @"Start Running!!";
    start.locked = false;//to prevent expanding
    [start.addRunButton setImage:[UIImage imageNamed:@"whiteaddrun.png"] forState:UIControlStateNormal];
    [start.folderImage setHidden:false];
}

#pragma mark -
#pragma mark Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    
    if(buttonIndex == 0)
    {
        [self.delegate finishedRun:nil];
    }
}


#pragma mark -
#pragma mark Nav Bar Action

-(void)cleanupForNav
{
    //take down logger
    
    
}


- (IBAction)performanceNavPressed:(id)sender {
    
    //nav bar cleanup
    [self cleanupForNav];
    
    PerformanceViewController * vc = [[PerformanceViewController alloc] initWithNibName:@"Performance" bundle:nil];
    
    [self presentViewController:vc animated:true completion:nil];
}

- (IBAction)goalsNavPressed:(id)sender {
    
    //nav bar cleanup
    [self cleanupForNav];
    
    if(!core.curGoal)
    {
        
        CreateGoalViewController * vc = [[CreateGoalViewController alloc] initWithNibName:@"CreateGoal" bundle:nil];
        
        [self presentViewController:vc animated:true completion:nil];
    }
    else
    {
        GoalsViewController * vc = [[GoalsViewController alloc] initWithNibName:@"Goals" bundle:nil];
        
        [self presentViewController:vc animated:true completion:nil];
    
    }
}

- (IBAction)settingsNavPressed:(id)sender {
    
    //nav bar cleanup
    [self cleanupForNav];
    
    SettingsViewController * vc = [[SettingsViewController alloc] initWithNibName:@"Settings" bundle:nil];
    
    [self presentViewController:vc animated:true completion:nil];
}




#pragma mark -
#pragma mark StartCell Actions

-(void)testNewRun
{
    
    RunEvent * new = [[RunEvent alloc] initWithName:@"geoff's run" date:[NSDate date]];
    new.live = true;
    [self selectedNewRun:new];
    
}

- (IBAction)paceTapped:(id)sender {
    PacePicker *pace = [[PacePicker alloc] initWithTitle:@" Pace " rows:nil initialSelection:0 target:self successAction:@selector(testNewRun) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    [pace addCustomButtonWithTitle:@"PR" value:nil];
    
    [pace showRunFormPicker];
    
}

- (IBAction)timeTapped:(id)sender {
    
    TimePicker *time = [[TimePicker alloc] initWithTitle:@" Time " rows:nil initialSelection:0 target:self successAction:@selector(testNewRun) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    [time addCustomButtonWithTitle:@"PR" value:nil];
    
    [time showRunFormPicker];
}

- (IBAction)calorieTapped:(id)sender {
    
    
    
    CaloriePicker *cal = [[CaloriePicker alloc] initWithTitle:@"Calories" rows:nil initialSelection:0 target:self successAction:@selector(testNewRun) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    [cal addCustomButtonWithTitle:@"PR" value:nil];
    
    [cal showRunFormPicker];
}

- (IBAction)justGoTapped:(id)sender {
    
    [self testNewRun];
    
}

- (IBAction)distanceTapped:(id)sender {
    
    DistancePicker *distance = [[DistancePicker alloc] initWithTitle:@" Distance " rows:nil initialSelection:0 target:self successAction:@selector(testNewRun) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    [distance addCustomButtonWithTitle:@"PR" value:nil];
    
    [distance showRunFormPicker];
}
@end
