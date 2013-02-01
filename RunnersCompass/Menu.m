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
#import "Settings.h"
#import "GoalsViewController.h"



@implementation MenuViewController

@synthesize MenuTable;
@synthesize pauseImage;



#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
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
        
        [run setMap:map];
        
        [runs addObject:run];
        
    }
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return number of historic runs plus start menu
    return [runs count] + 1;
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    if(row == 0)
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
    else if(row > [cells count]){
        HierarchicalCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"HierarchicalCell"
                                                 owner:self
                                               options:nil]objectAtIndex:0];
        [cell setAssociated:[runs objectAtIndex:row-1]];
        [cell setDelegate:self];
        
        [cells addObject:cell];
        
        return cell;
    }
    else{
        
        
        HierarchicalCell * curCell = [cells objectAtIndex:row-1];
        
        return curCell;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    NSUInteger row = [indexPath row];
    if(row == 0)
    {
        height = [start getHeightRequired];
        
    }
    else if(row-1< [cells count]){
        HierarchicalCell * cell = [cells objectAtIndex:row-1];
    
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
    
    if(row > ([cells count] + 1) || row == 0)
        return;
    
    
    HierarchicalCell * cell = [cells objectAtIndex:row-1];
    
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
    
    //still need to animate hidden expandedView
    
    //if sender was last cell or second last, then scroll to show expanded view
    if(sender == [cells lastObject] || [cells objectAtIndex:([cells count] -1)])
    {
        NSIndexPath *path = [MenuTable indexPathForCell:sender];
        [MenuTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:true];
    }
}


#pragma mark -
#pragma mark StartCellDelegate

-(void)selectedNewRun:(RunEvent *) run
{
    //set logger with this run
    [self.delegate loadRun:run];
    
}


#pragma mark -
#pragma mark Logger Interface


-(void)selectedRun:(id)sender
{
    
    HierarchicalCell * cell = (HierarchicalCell * )sender;
    
    
    //set logger with this run
    [self.delegate loadRun:cell.associatedRun];
    
    
}


- (void)isBouncing:(CGFloat)differential changeState:(BOOL)changeState{
    
    NSLog(@"%f", differential);
    
    CGFloat percent = differential / 100.0f;
    
    [UIView animateWithDuration:0.0f
                     animations:^
     {
         pauseImage.transform = CGAffineTransformMakeScale(percent,percent);
     }];
    
    if(percent > 0.8f)
    {
        if(changeState){
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"pauseToggleNotification"
             object:pauseImage];
        }
    }
    
    [MenuTable setHidden:true];
    [pauseImage setHidden:false];
    [self.navigationController.navigationBar setHidden:true];
    
}

-(void)resetViewFromSlider
{
    [MenuTable setHidden:false];
    [pauseImage setHidden:true];
    [self.navigationController.navigationBar setHidden:false];
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
    
    [self.navigationController pushViewController:vc animated:YES];
    [self.view addSubview: vc.view];
}

- (IBAction)goalsNavPressed:(id)sender {
    
    //nav bar cleanup
    [self cleanupForNav];
    
    GoalsViewController * vc = [[GoalsViewController alloc] initWithNibName:@"Goals" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    [self.view addSubview: vc.view];
}

- (IBAction)settingsNavPressed:(id)sender {
    
    //nav bar cleanup
    [self cleanupForNav];
    
    Settings * vc = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    [self.view addSubview: vc.view];
}
@end
