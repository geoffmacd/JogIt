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
#import "RunEvent.h"
#import "GoalCell.h"

@implementation GoalsViewController

@synthesize table,curGoal,header,prefs,originalRunsSorted;

static NSString * goalCellID = @"GoalCellPrototype";

- (void)viewDidAppear:(BOOL)animated
{
    if(drilledDown)
    {
                
        [table setUserInteractionEnabled:true];
        [table setScrollEnabled:true];
        
        //stupid hack
        table.contentSize = CGSizeMake(self.view.frame.size.width, header.frame.size.height + (goalRunCount * 44));
        [table reloadData];
        [table setNeedsDisplay];
        
        drilledDown = false;
    }
    
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
        
        //add more rows for added metrics
        [table reloadData];
    }
    
    if(curGoal.type == GoalTypeNoGoal)
    {
        //size table to nothing to prevent scrolling
        [table setContentSize:CGSizeMake(self.view.frame.size.width, 0)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goalChanged:)
                                                 name:@"goalChangedNotification"
                                               object:nil];
    
    cells = [[NSMutableArray alloc] initWithCapacity:100];
    sortedRunsForGoal = [[NSMutableArray alloc] initWithCapacity:100];
    
    //load cell
    [table registerClass:[GoalCell class] forCellReuseIdentifier:goalCellID];
    UINib * nib = [UINib nibWithNibName:@"GoalCell" bundle:[NSBundle mainBundle]] ;
    [table registerNib:nib forCellReuseIdentifier:goalCellID];
    
    if(curGoal)
    {
        [self sortRunsForGoal];
        //process goal
        [curGoal processGoalForRuns:sortedRunsForGoal withMetric:[[prefs metric] boolValue]];
    }
    
    drilledDown = false;
}

-(void)setOriginalRunsSorted:(NSMutableArray *)tempArray
{
    totalRunCount = [tempArray count];
    
    NSArray *sortedArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(RunEvent*)a date];
        NSDate *second = [(RunEvent*)b date];
        return [second compare:first];
    }];
    originalRunsSorted = [sortedArray mutableCopy];
}

-(void)sortRunsForGoal
{
    NSAssert(originalRunsSorted, @"no original runs to sort");
    
    //set initial array to include all
    NSArray * tempArray = [originalRunsSorted mutableCopy];
    [sortedRunsForGoal removeAllObjects];
    
    //min, max value
    minValueForGoal = 0;
    maxValueForGoal = 0;
    
    //already sorted so that first object is latest date
    for(RunEvent * runToConsider in tempArray)
    {
        if(curGoal.endDate)
        {
            if (([runToConsider.date compare:curGoal.startDate ] == NSOrderedDescending) &&
                ([runToConsider.date compare:curGoal.endDate] == NSOrderedAscending))
            {
                [sortedRunsForGoal addObject:runToConsider];
                
                //calc  value for goal
                switch(curGoal.type)
                {
                    case GoalTypeCalories:
                        if(runToConsider.calories < minValueForGoal)
                            minValueForGoal = runToConsider.calories;
                        else if(runToConsider.calories > maxValueForGoal)
                            maxValueForGoal = runToConsider.calories ;
                        break;
                    case GoalTypeOneDistance:
                        //not used
                        break;
                    case GoalTypeRace:
                        if(runToConsider.avgPace < minValueForGoal)
                            minValueForGoal = runToConsider.avgPace;
                        else if(runToConsider.avgPace > maxValueForGoal)
                            maxValueForGoal = runToConsider.avgPace ;
                        break;
                    case GoalTypeTotalDistance:
                        if(runToConsider.distance < minValueForGoal)
                            minValueForGoal = runToConsider.distance;
                        else if(runToConsider.distance > maxValueForGoal)
                            maxValueForGoal = runToConsider.distance ;
                        break;
                    default:
                        break;
                }
            }
        }
        else
        {
            if ([runToConsider.date compare:curGoal.startDate ] == NSOrderedDescending)
            {
                [sortedRunsForGoal addObject:runToConsider];
                
                //calc  value for goal
                switch(curGoal.type)
                {
                    case GoalTypeCalories:
                        if(runToConsider.calories < minValueForGoal)
                            minValueForGoal = runToConsider.calories;
                        else if(runToConsider.calories > maxValueForGoal)
                            maxValueForGoal = runToConsider.calories ;
                        break;
                    case GoalTypeOneDistance:
                        //not used
                        break;
                    case GoalTypeRace:
                        if(runToConsider.avgPace < minValueForGoal)
                            minValueForGoal = runToConsider.avgPace;
                        else if(runToConsider.avgPace > maxValueForGoal)
                            maxValueForGoal = runToConsider.avgPace ;
                        break;
                    case GoalTypeTotalDistance:
                        if(runToConsider.distance < minValueForGoal)
                            minValueForGoal = runToConsider.distance;
                        else if(runToConsider.distance > maxValueForGoal)
                            maxValueForGoal = runToConsider.distance ;
                        break;
                    default:
                        break;
                }
            }
        }
    }
    
    //set correct number of rows to show
    goalRunCount = [sortedRunsForGoal count];
}

-(void)goalChanged:(NSNotification *)notification
{
    
    //set new settings
    curGoal = (Goal *) [notification object];
    
    //be ready to redraw cells
    [cells removeAllObjects];
    
    //sort runs for goal
    [self sortRunsForGoal];
    //process goal
    [curGoal processGoalForRuns:sortedRunsForGoal withMetric:[[prefs metric] boolValue]];
    
    header = nil;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UpgradeVC Delegate

-(void)didPurchase
{
    prefs.purchased = [NSNumber numberWithBool:true];
    showPurchaseNotification = true;
}

#pragma mark -
#pragma mark  Table data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    if(tv == table)
        return 1;
    else
        return 0;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return number of relevant runs for goal
    //NSLog(@"%@", [tableView description]);
    if(tableView == table)
        return goalRunCount;
    else
        return 0;
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    //NSLog(@"row: %d with array: %d", row, goalRunCount);
    
    if(row >= [cells count])
    {
        /*
        GoalCell * cell = (GoalCell*) [[[NSBundle mainBundle]loadNibNamed:@"GoalCell"
                                                                 owner:self
         options:nil]objectAtIndex:0];*/
        GoalCell * cell = (GoalCell * )[tableView dequeueReusableCellWithIdentifier:goalCellID];
        
        [cells addObject:cell];
        RunEvent * runForCell = [sortedRunsForGoal objectAtIndex:row];
        [cell setupWithRun:runForCell withGoal:curGoal withMetric:[[prefs metric] boolValue] showSpeed:[[prefs showSpeed] boolValue] withMin:minValueForGoal withMax:maxValueForGoal];
        
        
        return cell;
    }
    else{
        
        
        GoalCell * curCell = [cells objectAtIndex:row];
        
        return curCell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
}

#pragma mark -
#pragma mark  Table delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //deliver goalheadercell
    if(!header)
    {
        header = (GoalHeaderCell*) [[[NSBundle mainBundle]loadNibNamed:@"GoalHeaderCell"
                                                      owner:self
                                                               options:nil]objectAtIndex:0];
        [header setMetric:[[prefs metric] boolValue] ];
        [header setGoal:curGoal];
        [header setup];
    }
    
    return header;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!header)
    {
        header =  (GoalHeaderCell*) [[[NSBundle mainBundle]loadNibNamed:@"GoalHeaderCell"
                                                owner:self
                                                                options:nil]objectAtIndex:0];
        [header setMetric:[[prefs metric] boolValue] ];
        [header setGoal:curGoal];
        [header setup];
    }
    
    CGFloat height = header.frame.size.height;
    
    //return height of header, does not change
    return height;
}

#pragma mark - UI actions


- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)goalTapped:(id)sender {
    
    /*
    drilledDown = true;
    
    CreateGoalViewController  * vc = [[CreateGoalViewController alloc] initWithNibName:@"CreateGoal" bundle:nil];
    [vc setGoal:curGoal];
    [vc setPrefs:prefs];
    
     [self presentViewController:vc animated:true completion:nil];
     */
    
    if([prefs.purchased boolValue])
    {
        drilledDown = true;
        
        CreateGoalViewController  * vc = [[CreateGoalViewController alloc] initWithNibName:@"CreateGoal" bundle:nil];
        [vc setGoal:curGoal];
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
@end
