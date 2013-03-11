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
    
        
        //load most recent run on startup, but not intended any other time
        RunEvent * loadRun = [[RunEvent alloc] initWithNoTarget];
        loadRun.live = false;
        NSMutableArray * loadPos = [[NSMutableArray alloc] initWithCapacity:1000];
        //begin run now with no other pause points
        [loadRun setPausePoints:[[NSMutableArray alloc] initWithObjects:[NSDate date]  , nil]];
        
        for(int i = 0; i < 300; i ++)
        {
            RunPos *posToAdd = [[RunPos alloc] init];
            
            posToAdd.pos =  CGPointMake(arc4random() % 100, arc4random() % 100);
            posToAdd.pace =  arc4random() % 100;//100 * ((CGFloat)i/100.0);
            posToAdd.elevation =  arc4random() % 100;
            posToAdd.time=  i;
            
            
            [loadPos addObject:posToAdd];
        }
        
        [loadRun setPos:loadPos];
        [loadRun setCheckpoints:loadPos];
        
        [loadRun setLive:false];
        
        [loadRun setMap:map];
        
        [runs addObject:loadRun];
        
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
        [cell setDelegate:self];
        [cell setAssociated:[runs objectAtIndex:row]];

        
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
    //never called, since the cells button is called first 
    
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCellDeletionModeAfterTouch"
                                                        object:nil];
    
    //animate with row belows move down nicely
    [MenuTable beginUpdates];
    [MenuTable endUpdates];
    [MenuTable reloadData];//needed to have user interaction on start cell if this is expanded, also removes white line issue
    
    
    //if sender was last cell or second last, then scroll to show expanded view
    //ensure there is at least something to avoid crash from pressing the startcell
    if(sender == [cells lastObject])
    {
        NSIndexPath *path = [MenuTable indexPathForCell:sender];
        [MenuTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:true];
    }
    else if([cells count] > 1)
    {
        if(sender == [cells objectAtIndex:([cells count] - 2)])
        {
            NSIndexPath *path = [MenuTable indexPathForCell:sender];
            [MenuTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:true];
        }
    }
}

-(void)updateGestureFailForCell:(UIGestureRecognizer*)cellGesture
{
    
    [self.delegate updateGesturesNeededtoFail:cellGesture];
}


#pragma mark -
#pragma mark Start Cell Delegate

-(void)selectedRunInProgress:(BOOL)shouldDiscard
{
    //selected the headerview of start cell when run is in progress, slide back to logger
    [self.delegate selectedRunInProgress:shouldDiscard];

    
}

-(void)selectedNewRun:(RunEvent *) run
{
    [self cleanupForNav];
    
    //set logger with this run
    [self.delegate newRun:run animate:true];
    
    runInProgressAsFarAsICanTell = true;
    
    //modifiy header to indicate progressing run
    start.headerLabel.text = NSLocalizedString(@"RunInProgressTitle", @"start cell title for runs in progress");
    [start setExpand:false withAnimation:true];
    start.locked = true;//to prevent expanding
    [start.addRunButton setImage:[UIImage imageNamed:@"garbagecan.png"] forState:UIControlStateNormal];
    [start.folderImage setHidden:true];
    
}




#pragma mark -
#pragma mark Logger Interface

//also heierachical cell delegate method
-(void)selectedRun:(id)sender
{
    [self cleanupForNav];
    
    if(!runInProgressAsFarAsICanTell)
    {
        HierarchicalCell * cell = (HierarchicalCell * )sender;
        
        //set logger with this run
        [self.delegate loadRun:cell.associatedRun close:true];
        
        //refresh start cell
        runInProgressAsFarAsICanTell = false;
        [start.headerLabel setText:NSLocalizedString(@"StartRunTitle", @"Title for start cell")];
        start.locked = false;//to prevent expanding
        [start.addRunButton setImage:[UIImage imageNamed:@"whiteaddrun.png"] forState:UIControlStateNormal];
        [start.folderImage setHidden:false];
    
    }
    
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
    [start.headerLabel setText:NSLocalizedString(@"StartRunTitle", @"Title for start cell")];
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
    //stuff to do before navigation like take down garbage cans
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCellDeletionModeAfterTouch"
                                                        object:nil];
    
    
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
        //go straight to create screen since their is no goal to show
        
        //CreateGoalViewController * vc2 = [[CreateGoalViewController alloc] initWithNibName:@"CreateGoal" bundle:nil];
        
        //[self presentViewController:vc2 animated:true completion:nil];
        
        
        GoalsViewController * vc = [[GoalsViewController alloc] initWithNibName:@"Goals" bundle:nil];
        CreateGoalViewController * vc2 = [[CreateGoalViewController alloc] initWithNibName:@"CreateGoal" bundle:nil];
        
        [self presentViewController:vc animated:true completion:^{
            
            [vc presentViewController:vc2 animated:true completion:nil];
        }];
        
        
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

-(void)paceRunStart:(NSNumber*)selectedIndex
{
    CGFloat pace = 0.5 + ([selectedIndex intValue] * 0.5);
    
    RunEvent * new = [[RunEvent alloc] initWithTarget:MetricTypePace withValue:pace];
    
    [self selectedNewRun:new];
    
}

-(void)distanceRunStart:(NSNumber*)selectedIndex
{
    CGFloat distance = 0.5 + ([selectedIndex intValue] * 0.5);
    
    RunEvent * new = [[RunEvent alloc] initWithTarget:MetricTypeDistance withValue:distance];
    
    [self selectedNewRun:new];
    
}

-(void)timeRunStart:(NSNumber*)selectedIndex
{
    CGFloat time = 0.5 + ([selectedIndex intValue] * 0.5);
    
    RunEvent * new = [[RunEvent alloc] initWithTarget:MetricTypeTime withValue:time];
    
    [self selectedNewRun:new];
    
}

-(void)caloriesRunStart:(NSNumber*)selectedIndex
{
    CGFloat calories = 0.5 + ([selectedIndex intValue] * 0.5);
    
    RunEvent * new = [[RunEvent alloc] initWithTarget:MetricTypeCalories withValue:calories];
    
    [self selectedNewRun:new];
    
}


-(void)justGoStart
{
    
    RunEvent * new = [[RunEvent alloc] initWithNoTarget];
    
    [self selectedNewRun:new];
    
}

- (IBAction)paceTapped:(id)sender {
    PacePicker *pace = [[PacePicker alloc] initWithTitle:[NSString stringWithFormat:@"Pace (min/%@)", [core.prefs getDistanceUnit]]  rows:nil initialSelection:0 target:self successAction:@selector(paceRunStart:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    [pace addCustomButtonWithTitle:@"PR" value:nil];
    
    [pace showRunFormPicker];
    
}

- (IBAction)timeTapped:(id)sender {
    
    TimePicker *time = [[TimePicker alloc] initWithTitle:@"Time" rows:nil initialSelection:0 target:self successAction:@selector(timeRunStart:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    [time addCustomButtonWithTitle:@"PR" value:nil];
    
    [time showRunFormPicker];
}

- (IBAction)calorieTapped:(id)sender {
    
    
    
    CaloriePicker *cal = [[CaloriePicker alloc] initWithTitle:@"Calories" rows:nil initialSelection:0 target:self successAction:@selector(caloriesRunStart:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    [cal addCustomButtonWithTitle:@"PR" value:nil];
    
    [cal showRunFormPicker];
}

- (IBAction)justGoTapped:(id)sender {
    
    [self justGoStart];
    
}

- (IBAction)distanceTapped:(id)sender {
    
    
    DistancePicker *distance = [[DistancePicker alloc] initWithTitle:[NSString stringWithFormat:@"Distance (%@)", [core.prefs getDistanceUnit]] rows:nil initialSelection:0 target:self successAction:@selector(distanceRunStart:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    [distance addCustomButtonWithTitle:@"PR" value:nil];
    
    [distance showRunFormPicker];
}

- (IBAction)garbageTapped:(id)sender {
    
    //remove cell
    UIButton * cellButtonTapped = sender;
    NSUInteger indexOfCell = 10000;
    
    for(int i = 0; i < [cells count]; i++)
    {
        if([cellButtonTapped isDescendantOfView:[cells objectAtIndex:i]])
        {
            indexOfCell = i;
            break;
            
        }
    }
    
    if(indexOfCell != 10000)
    {
        HierarchicalCell * cellToDelete = [cells objectAtIndex:indexOfCell];
        
        //gauranteed to be the correct row number since the array is reloaded along with the table
        NSIndexPath * indexToDelete = [NSIndexPath indexPathForRow:indexOfCell inSection:0];
        
        NSArray *arrayToDeleteCells = [NSArray arrayWithObject:indexToDelete];
        
        RunEvent * runDeleting = [cellToDelete associatedRun];
        
        //if run is currently loaded in the logger replace with something else
        [self.delegate preventUserFromSlidingRunInvalid:runDeleting];
        
        //remove both run and cell, run is most necessary
        [runs removeObject:runDeleting];
        [cells removeObjectAtIndex:indexOfCell];
        
        //commit and reload table here
        [MenuTable deleteRowsAtIndexPaths:arrayToDeleteCells withRowAnimation:UITableViewRowAnimationLeft];
    
    }
    else{
        NSLog(@"Cant find cell to delete");
    }
}

@end
