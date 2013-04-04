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

@synthesize table,curGoal,header,metric,originalRunsSorted;

static NSString * goalCellID = @"GoalCellPrototype";

- (void)viewDidAppear:(BOOL)animated
{
    if(drilledDown)
    {
        [cells removeAllObjects];
        [self sortRunsForGoal];
        [header setGoal:curGoal];
        [header setup];
        [table setUserInteractionEnabled:true];
        [table setScrollEnabled:true];
        //stupid hack
        table.contentSize = CGSizeMake(self.view.frame.size.width, header.frame.size.height + (goalRunCount * 44));
        [table reloadData];
    }
    drilledDown = false;
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
    
    //already sorted so that first object is latest date
    for(RunEvent * runToConsider in tempArray)
    {
        if (([runToConsider.date compare:curGoal.startDate ] == NSOrderedDescending) &&
            ([runToConsider.date compare:curGoal.endDate] == NSOrderedAscending))
        {
            [sortedRunsForGoal addObject:runToConsider];
        }
    }
    
    //set correct number of rows to show
    goalRunCount = [sortedRunsForGoal count];
}

-(void)goalChanged:(NSNotification *)notification
{
    
    //set new settings
    curGoal = (Goal *) [notification object];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"row: %d with array: %d", row, goalRunCount);
    
    if(row >= [cells count]){
        
        //GoalCell * cell = (GoalCell * )[tableView dequeueReusableCellWithIdentifier:goalCellID];
        
        GoalCell * cell = (GoalCell*) [[[NSBundle mainBundle]loadNibNamed:@"GoalCell"
                                                                 owner:self
                                                               options:nil]objectAtIndex:0];
        
        [cells addObject:cell];
        RunEvent * runForCell = [sortedRunsForGoal objectAtIndex:row];
        [cell setupWithRun:runForCell withGoal:curGoal withMetric:metric];
        
        
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
    
    drilledDown = true;
    
    CreateGoalViewController  * vc = [[CreateGoalViewController alloc] initWithNibName:@"CreateGoal" bundle:nil];
    [vc setGoal:curGoal];
    
    [self presentViewController:vc animated:true completion:nil];
    
}
@end
