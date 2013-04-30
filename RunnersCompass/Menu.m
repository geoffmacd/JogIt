//
//  MenuViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import "Menu.h"


@implementation MenuViewController

@synthesize MenuTable;
@synthesize runInProgressAsFarAsICanTell;
@synthesize settingsBut,performanceBut,goalsBut;
@synthesize runningManImage,noRunsLabel;
@synthesize noRunView;
@synthesize delegate;

static NSString * dateCellID = @"DateCellPrototype";

#pragma mark -
#pragma mark View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    cells = [[NSMutableArray alloc] initWithCapacity:3];// 3 months

    //find all runs
    NSArray * runRecords = [RunRecord MR_findAllSortedBy:@"date" ascending:false];
    
    //determine PRs here first
    for(RunRecord * runRecord in runRecords)
    {
        //init RunEvent with data
        RunEvent * eventToAdd = [[RunEvent alloc] initWithRecord:runRecord];
        
        [runs addObject:eventToAdd];
    }
    
    //determine PRs
    [self analyzePRs];
    
    runInProgressAsFarAsICanTell = false;
    
    //no run stuff
    showingNoRuns = false;
    [noRunsLabel setText:NSLocalizedString(@"NoRunsLabel", @"label describing no runs in menu")];
    
    //load cell
    [MenuTable registerClass:[DateCell class] forCellReuseIdentifier:dateCellID];
    UINib * nib = [UINib nibWithNibName:@"DateCell" bundle:[NSBundle mainBundle]] ;
    [MenuTable registerNib:nib forCellReuseIdentifier:dateCellID];
    
    //allow menu table to scroll to top
    [MenuTable setScrollsToTop:true];
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
#pragma mark PR management

-(void)analyzePRs
{
    furthestRun = nil;
    fastestRun = nil;
    caloriesRun = nil;
    longestRun = nil;
    
    for(RunEvent * oldRun in runs)
    {
        //check for PRs
        if(furthestRun)
        {
            if(furthestRun.distance < oldRun.distance)
            {
                furthestRun = oldRun;
            }
        }
        else
        {
            furthestRun = oldRun;
        }
        if(fastestRun)
        {   //special restriction for speed in case it's zero
            if(fastestRun.avgPace < oldRun.avgPace && oldRun.avgPace < maxSpeedForPR)
            {
                fastestRun = oldRun;
            }
        }
        else
        {
            fastestRun = oldRun;
        }
        if(caloriesRun)
        {
            if(caloriesRun.calories < oldRun.calories)
            {
                caloriesRun = oldRun;
            }
        }
        else
        {
            caloriesRun = oldRun;
        }
        if(longestRun)
        {
            if(longestRun.time < oldRun.time)
            {
                longestRun = oldRun;
            }
        }
        else
        {
            longestRun = oldRun;
        }
    }
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
            [cell setDelegate:self];
            [cell setup];
            
            start = cell;
            
        }
        
        return start;
        
    }
    
    return nil;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //get number of periods for runs
    UserPrefs * curPrefs = [self getPrefs];

    numPeriods = [Util numPeriodsForRuns:runs withWeekly:[[curPrefs weekly] boolValue]];
    
    //need at least one date
    if(numPeriods <= 0)
        return 1;
    
    return numPeriods;
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    

    if(row >= [cells count]){
        
        DateCell * cell = (DateCell * )[tableView dequeueReusableCellWithIdentifier:dateCellID];
        
        BOOL isWeekly = [[[self getPrefs] weekly] boolValue];
        
        [cells addObject:cell];
        [cell setDelegate:self];
        //determine runs to allocate
        [cell setPeriodStart:[Util dateForPeriod:row withWeekly:isWeekly]];
        [cell setRuns:[Util runsForPeriod:runs withWeekly:isWeekly withPeriodStart:cell.periodStart]];
        //all prefs are requested
        [cell setup];

        
        return cell;
    }
    else{
        
        
        DateCell * curCell = [cells objectAtIndex:row];
        
        return curCell;
    } 
}

#pragma mark -
#pragma mark Menu Table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    NSUInteger row = [indexPath row];
    
    if(row >= [cells count]){
        
        //delay dequeueing, not to be done here for performance
        
        height = 64.0f;
    }
    else{
        
        DateCell * cell = [cells objectAtIndex:row];
        
        height = [cell getHeightRequired];
    }

    return height;
}

#pragma mark -
#pragma mark DateCellDelegate

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
    else if([cells count] > 1 )
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
    
    [delegate updateGesturesNeededtoFail:cellGesture];
}

-(UserPrefs*)getPrefs
{
    UserPrefs * prefs = [self.delegate curUserPrefs];
    
    return prefs;
    
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
    
    
    //modifiy header to indicate progressing run
    runInProgressAsFarAsICanTell = true;
    [start.timeLabel setHidden:false];
    start.headerLabel.text = NSLocalizedString(@"RunInProgressTitle", @"start cell title for runs in progress");
    [start setExpand:false withAnimation:true];
    start.locked = true;//to prevent expanding
    [start.garbageBut setHidden:false];
    [start.addRunButton setHidden:true];
    [start.folderImage setHidden:true];
    
}

#pragma mark -
#pragma mark Manual VC Delegate

-(void)manualRunToSave:(RunEvent*)runToSave
{
    if(runToSave)
    {
        //run saved to DB in manual VC
        
        //save usual way , same as with logger
        [self finishedRun:runToSave];
        
        //hide start cell
        [start setExpand:false withAnimation:true];
    }
}

-(void)manualRunCancelled
{
    //do nothing
}

#pragma mark -
#pragma mark Logger Interface with app delegate

//also heierachical cell delegate method
-(void)selectedRun:(id)sender
{
    [self cleanupForNav];
    
    NSLog(@"Selected Run from Menu %f",[NSDate timeIntervalSinceReferenceDate]);
    
    if(!runInProgressAsFarAsICanTell)
    {
        HierarchicalCell * cell = (HierarchicalCell * )sender;
        
        //if associated is manual, don't load, just shake manual label
        if(cell.associatedRun.eventType ==EventTypeManual)
        {
            [AnimationUtil shakeView:cell.manualEntryLabel];
            //do not load
            return;
        }
        
        //if run is already loaded, slide to logger
        if([delegate isRunAlreadyLoaded:cell.associatedRun])
        {
            [delegate selectedRunInProgress:false];
            return;
        }
        
        //need to fetch real record and fill with data points
        RunRecord * recordToLoad = [RunRecord MR_findFirstByAttribute:@"date" withValue:cell.associatedRun.date];
        
        //only show progress if cell is big enough to justify
        if([[recordToLoad time] doubleValue] > loadTimeMinForProgress)
        {
            //lock slider before beginning load
            [delegate lockBeforeLoad];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                //takes a long time
                RunEvent * runToLoad = [[RunEvent alloc] initWithRecordToLogger:recordToLoad];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //set logger with this run
                    [self.delegate loadRun:runToLoad close:true];
                });
            });
        }
        else
        {
            RunEvent * runToLoad = [[RunEvent alloc] initWithRecordToLogger:recordToLoad];
            //set logger with this run
            [self.delegate loadRun:runToLoad close:true];
        }
        
        //refresh start cell
        runInProgressAsFarAsICanTell = false;
        [start.timeLabel setHidden:true];
        [start.headerLabel setText:NSLocalizedString(@"StartRunTitle", @"Title for start cell")];
        start.locked = false;//to prevent expanding
        [start.garbageBut setHidden:true];
        [start.addRunButton setHidden:false];
        [start.folderImage setHidden:false];
    
    }
    else{
        //shake run in progress title
        [AnimationUtil shakeView:start.headerLabel];
    }
}

-(void) finishedRun:(RunEvent*)finishedRun
{
    
    //save run and add it to the menu if it exists
    if(finishedRun)
    {
        //determine index to insert run into since date can be different due to manual entry
        NSInteger indexToInsert = -1;
        //should be currently sorted such that highest (latest) date is at index 0
        for(int i = 0; i <  [runs count]; i++)
        {
            RunEvent * oldRun = [runs objectAtIndex:i];
            //until run to save is greater than old run
            if([oldRun.date timeIntervalSinceReferenceDate] > [finishedRun.date timeIntervalSinceReferenceDate])
            {
                indexToInsert = i;
            }
        }
        if(indexToInsert == -1)
        {
            //add to very top
            [runs insertObject:finishedRun atIndex:0];
            //to zoom on table path correctly
            indexToInsert = 0;
        }
        else if(indexToInsert == [runs count]-1)
        {
            //very end of list
            [runs addObject:finishedRun];
        }
        else
        {
            indexToInsert++;
            //insert at correct index
            [runs insertObject:finishedRun atIndex:indexToInsert];
        }
        
        [MenuTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToInsert inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [cells removeAllObjects];
        [MenuTable reloadData];
        
        //scroll to top
        [MenuTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexToInsert inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
        
        BOOL alreadyPresentedNotification = false;
        
        //display goal achieved notification regardless of manual or not
        Goal * curGoal = [delegate curGoal];
        //did new run cause goal to be complete and wasn't completed before hand
        if(curGoal.type != GoalTypeNoGoal)
        {
            //reprocess and new progress will be saved
            //need sorted runs
            NSMutableArray * runsToProcess = [[NSMutableArray alloc] initWithCapacity:[runs count]];
            
            //already sorted so that first object is latest date
            for(RunEvent * runToConsider in runs)
            {
                if(curGoal.endDate)
                {
                    if (([runToConsider.date compare:curGoal.startDate ] == NSOrderedDescending) &&
                        ([runToConsider.date compare:curGoal.endDate] == NSOrderedAscending))
                    {
                        [runsToProcess addObject:runToConsider];
                    }
                }
                else
                {
                    if ([runToConsider.date compare:curGoal.startDate ] == NSOrderedDescending)
                    {
                        [runsToProcess addObject:runToConsider];
                    }
                }
            }
            
            //run must be present in array otherwise , it's date is out of range
            if([runsToProcess count] > 0 && [runsToProcess containsObject:finishedRun])
            {
                //only if goal wasn't previously completed
                [runsToProcess removeObject:finishedRun];
                if(![curGoal processGoalForRuns:runsToProcess withMetric:[[[delegate curUserPrefs] metric] boolValue]])
                {
                    [runsToProcess addObject:finishedRun];
                    if([curGoal processGoalForRuns:runsToProcess withMetric:[[[delegate curUserPrefs] metric] boolValue]])
                    {
                        //present PR notification popup
                        GoalNotifyVC * vc = [[GoalNotifyVC alloc] initWithNibName:@"GoalNotifyVC" bundle:nil];
                        [vc setPrefs:[delegate curUserPrefs]];
                        [vc setPrRun:finishedRun];
                        [vc setGoal:[delegate curGoal]];
                        
                        alreadyPresentedNotification = true;
                        [self presentPopupViewController:vc animationType:MJPopupViewAnimationSlideTopBottom];
                        [vc setLabels];
                    }
                }
            }
        }
        
        //determine if a new PR was made, unless it was manual
        if(finishedRun.eventType != EventTypeManual)
        {
            [self analyzePRs];
            
            //do not present notification if already popped up
            if(!alreadyPresentedNotification && ((finishedRun == longestRun) || (finishedRun == furthestRun)||(finishedRun == caloriesRun)||(finishedRun == fastestRun)))
            {
                //present PR notification popup
                NotificationVC * vc = [[NotificationVC alloc] initWithNibName:@"NotificationVC" bundle:nil];
                [vc setPrefs:[delegate curUserPrefs]];
                [vc setPrRun:finishedRun];
                //return yes if one of these runs if the checked
                if(finishedRun == fastestRun)
                    [vc setType:MetricTypePace];
                if (finishedRun == furthestRun)
                    [vc setType2:MetricTypeDistance];
                if(finishedRun == caloriesRun)
                    [vc setType3:MetricTypeCalories];
                if(finishedRun == longestRun)
                    [vc setType4:MetricTypeTime];
                
                [self presentPopupViewController:vc animationType:MJPopupViewAnimationSlideTopBottom];
                [vc setPRLabels];
            }
        }
    }
    
    //refresh start cell
    runInProgressAsFarAsICanTell = false;
    [start.timeLabel setHidden:true];
    [start.headerLabel setText:NSLocalizedString(@"StartRunTitle", @"Title for start cell")];
    start.locked = false;//to prevent expanding
    [start.garbageBut setHidden:true];
    [start.addRunButton setHidden:false];
    [start.folderImage setHidden:false];
}

-(void)updateTimeString:(NSString *)updatedTimeString
{
    //update label
    [start.timeLabel setText:updatedTimeString];
    
}

#pragma mark -
#pragma mark Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    
    //for discarding active run
    if(buttonIndex == 0)
    {
        //pass nil
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
    
    //prepare analyze data
    Analysis * analysisToSet = [[Analysis alloc] analyzeWithRuns:runs];
    [analysisToSet setCaloriesRun:caloriesRun];
    [analysisToSet setFastestRun:fastestRun];
    [analysisToSet setFurthestRun:furthestRun];
    [analysisToSet setLongestRun:longestRun];
    
    PerformanceVC * vc = [[PerformanceVC alloc] initWithNibName:@"Performance" bundle:nil];
    [vc setAnalysis:analysisToSet];
    [vc setPrefs:[self.delegate curUserPrefs]];
    
    [self presentViewController:vc animated:true completion:nil];
}
- (IBAction)goalsNavPressed:(id)sender {
    
    //nav bar cleanup
    [self cleanupForNav];
    
    GoalsViewController * vc = [[GoalsViewController alloc] initWithNibName:@"Goals" bundle:nil];
    [vc setPrefs:[delegate curUserPrefs]];
    [vc setCurGoal:[delegate curGoal]];
    [vc setOriginalRunsSorted:runs];
    [self presentViewController:vc animated:true completion:nil];
}

- (IBAction)settingsNavPressed:(id)sender {
    
    //nav bar cleanup
    [self cleanupForNav];
    
    SettingsViewController * vc = [[SettingsViewController alloc] initWithNibName:@"Settings" bundle:nil];
    
    //set current settings
    [vc setPrefsToChange:[self.delegate curUserPrefs]];
    [self presentViewController:vc animated:true completion:nil];
}

#pragma mark -
#pragma mark StartCell Actions

-(void)paceRunStart:(NSNumber*)selectedIndex
{
    CGFloat pace = [selectedIndex integerValue]; //s/km or s/mi
    
    //need m/s
    pace = 1000 / pace;
    
    //convert to imperial if neccessary
    UserPrefs * curPrefs = [delegate curUserPrefs];
    if(![curPrefs.metric boolValue])
    {
        pace = pace / convertKMToMile;
    }
    
    RunEvent * new = [[RunEvent alloc] initWithTarget:MetricTypePace withValue:pace withMetric:[curPrefs.metric boolValue] showSpeed:[curPrefs.showSpeed boolValue]];
    
    [self selectedNewRun:new];
    
}
-(void)distanceRunStart:(NSNumber*)selectedIndex
{
    CGFloat distance = 0.5 + ([selectedIndex intValue] * 0.5);
    
    //convert to mi or km
    UserPrefs * curPrefs = [delegate curUserPrefs];
    if(![curPrefs.metric boolValue])
    {
        distance = distance / convertKMToMile;
    }
    
    RunEvent * new = [[RunEvent alloc] initWithTarget:MetricTypeDistance withValue:distance*1000 withMetric:[[[delegate curUserPrefs] metric] boolValue] showSpeed:[[[delegate curUserPrefs] showSpeed] boolValue]];
    
    [self selectedNewRun:new];
    
}
-(void)timeRunStart:(NSNumber*)selectedIndex
{
    NSTimeInterval time = ([selectedIndex intValue] * 60);
    
    RunEvent * new = [[RunEvent alloc] initWithTarget:MetricTypeTime withValue:time withMetric:[[[delegate curUserPrefs] metric] boolValue] showSpeed:[[[delegate curUserPrefs] showSpeed] boolValue]];
    
    [self selectedNewRun:new];
    
}
-(void)caloriesRunStart:(NSNumber*)selectedIndex
{
    CGFloat calories = 25 + ([selectedIndex intValue] * 25);
    
    RunEvent * new = [[RunEvent alloc] initWithTarget:MetricTypeCalories withValue:calories withMetric:[[[delegate curUserPrefs] metric] boolValue] showSpeed:[[[delegate curUserPrefs] showSpeed] boolValue]];
    
    [self selectedNewRun:new];
    
}
-(void)justGoStart
{
    
    RunEvent * new = [[RunEvent alloc] initWithNoTarget];
    
    [self selectedNewRun:new];
    
}
- (IBAction)paceTapped:(id)sender {
    PacePicker *pace = [[PacePicker alloc] initWithTitle:[NSString stringWithFormat:@"Pace (min/%@)", [[self.delegate curUserPrefs] getDistanceUnit]]  rows:nil initialSelection:0 target:self successAction:@selector(paceRunStart:) cancelAction:@selector(actionPickerCancelled:) origin:sender];

    UserPrefs * curPrefs = [delegate curUserPrefs];
    
    //need PR in s/km form
    NSNumber * pRValue = [NSNumber numberWithInt:0];//1 min
    if(fastestRun)
    {
        if(fastestRun.avgPace >= 1.38889) //12 min/km minimum speed
        {
            CGFloat sKmSpeed = 1000 / fastestRun.avgPace; //convert to s/km from m/s
            if(![curPrefs.metric boolValue])
            {
                //convert to imperial if neccessary
                sKmSpeed = sKmSpeed * convertKMToMile;
            }
            //in s/km or s/mi 
            pRValue = [NSNumber numberWithInt:sKmSpeed];
        }
        else
            pRValue = [NSNumber numberWithInt:0];//0m 01s
    }
    //[pace addCustomButtonWithTitle:@"PR" value:pRValue];
    
    [pace showRunFormPicker];
    
}
- (IBAction)timeTapped:(id)sender {
    
    TimePicker *time = [[TimePicker alloc] initWithTitle:@"Time" rows:nil initialSelection:0 target:self successAction:@selector(timeRunStart:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    NSNumber * pRValue = [NSNumber numberWithInt:0];//1 min
    if(longestRun)
    {
        if(longestRun.time >= 60)
            pRValue = [NSNumber numberWithInt:(longestRun.time/60)];//+1 min above cur PR
        else
            pRValue = [NSNumber numberWithInt:0];//1 min
    }
    //[time addCustomButtonWithTitle:@"PR" value:pRValue];
    
    [time showRunFormPicker];
}

- (IBAction)calorieTapped:(id)sender {
    CaloriePicker *cal = [[CaloriePicker alloc] initWithTitle:@"Calories" rows:nil initialSelection:0 target:self successAction:@selector(caloriesRunStart:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
    NSNumber * pRValue = [NSNumber numberWithInt:0];//25 cal
    if(caloriesRun)
    {
        if(caloriesRun.calories <= 2525)
            pRValue = [NSNumber numberWithInt:(caloriesRun.calories/25)];//+25 above current PR
        else
            pRValue = [NSNumber numberWithInt:(2525/25)]; //2500 cal
    }
    //[cal addCustomButtonWithTitle:@"PR" value:pRValue];
    
    [cal showRunFormPicker];
}

- (IBAction)distanceTapped:(id)sender {
    
    
    DistancePicker *distance = [[DistancePicker alloc] initWithTitle:[NSString stringWithFormat:@"Distance (%@)", [[self.delegate curUserPrefs] getDistanceUnit]] rows:nil initialSelection:0 target:self successAction:@selector(distanceRunStart:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    NSNumber * pRValue = [NSNumber numberWithInt:0];//1 min
    if(furthestRun)
    {
        if(furthestRun.distance >= 500)//500 m min since 1st selection is 0.5km
            pRValue = [NSNumber numberWithInt:furthestRun.distance/500];//+0.5km above cur PR
        else
            pRValue = [NSNumber numberWithInt:0];//500m
    }
    //[distance addCustomButtonWithTitle:@"PR" value:pRValue];
    
    [distance showRunFormPicker];
}

- (IBAction)manualTapped:(id)sender {
    
    //goto manual VC
    
    //nav bar cleanup
    [self cleanupForNav];
    
    ManualVC * vc = [[ManualVC alloc] initWithNibName:@"Manual" bundle:nil];
    
    //set current settings
    [vc setPrefs:[self.delegate curUserPrefs]];
    [vc setDelegate:self]; 
    [self presentViewController:vc animated:true completion:nil];
    
    //do not dismiss start cell
    
}

- (IBAction)justGoTapped:(id)sender {
    
    [self justGoStart];
}


- (IBAction)garbageTapped:(id)sender {
    
    //remove cell
    UIButton * cellButtonTapped = sender;
    NSUInteger indexOfCell = 10000;
    
    //must find owner of the button that this was tapped by
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
        
        //delete from db
        RunRecord * recordToDelete = [RunRecord MR_findFirstByAttribute:@"date" withValue:runDeleting.date];
        //remove both run and cell, run is most necessary
        [runs removeObject:runDeleting];
        if(recordToDelete)
        {
            [recordToDelete MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
        [cells removeObjectAtIndex:indexOfCell];
        
        //commit and reload table here
        [MenuTable deleteRowsAtIndexPaths:arrayToDeleteCells withRowAnimation:UITableViewRowAnimationLeft];
        
        //reload 
        [MenuTable reloadData];
        
        //re-analyze PRs
        [self analyzePRs];

    }
    else{
        NSLog(@"Cant find cell to delete");
    }
}

@end
