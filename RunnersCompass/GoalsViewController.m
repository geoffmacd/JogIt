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

@interface GoalsViewController ()

@end

@implementation GoalsViewController

@synthesize table;
@synthesize goalButton;
@synthesize doneBut;
@synthesize goalActivitiesLabel,goalBeganLabel,goalTargetLabel,valueChangedDescription,progress;
@synthesize beganDateLabel,targetDateLabel,activitiesCountLabel, valueLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //set labels
    [self setGoalLabels];
    
    //set rounded corners on button
    [doneBut.layer setCornerRadius:8.0f];
    
    //set progress bar
    UIImage *trackImg = [[UIImage imageNamed:@"track.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    UIImage *progressImg = [[UIImage imageNamed:@"progress.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    [progress setTrackImage:trackImg];
    [progress setProgressImage:progressImg];
    
    
    //fake data
    runs = [[NSMutableArray alloc] initWithCapacity:3];
    for(NSInteger i=0;i <13; i++)
    {
        
        RunEvent * run = [[RunEvent alloc] initWithName:@"10.5 Km" date:[NSDate date]];
        
        [runs addObject:run];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setGoalLabels
{
    DataTest * data = [DataTest sharedData];
    if(data.curGoal)
    {
        [goalActivitiesLabel setHidden:false];
        [goalBeganLabel setHidden:false];
        [goalTargetLabel setHidden:false];
        [valueChangedDescription setHidden:false];
        
        [beganDateLabel setHidden:false];
        [targetDateLabel setHidden:false];
        [activitiesCountLabel setHidden:false];
        [valueLabel setHidden:false];
        
        [progress setHidden:false];
        [table setHidden:false];
        
        [goalButton setTitle:@"Lose 8 lbs by January 21st" forState:UIControlStateNormal];
        
        //fake
        [progress setProgress:0.7];
        [beganDateLabel setText:@"January 19th, 2012"];
        [targetDateLabel setText:@"August 13th, 2013"];
        [activitiesCountLabel setText:@"13"];
        [valueLabel setText:@"14,000 calories = 7 lbs"];
        
    }
    else
    {
        //set labels to blank
        [goalActivitiesLabel setHidden:true];
        [goalBeganLabel setHidden:true];
        [goalTargetLabel setHidden:true];
        [valueChangedDescription setHidden:true];
        
        [beganDateLabel setHidden:true];
        [targetDateLabel setHidden:true];
        [activitiesCountLabel setHidden:true];
        [valueLabel setHidden:true];
        
        [progress setHidden:true];
        [table setHidden:true];
        
        [goalButton setTitle:@"Create Goal" forState:UIControlStateNormal];
        
    }
}


#pragma mark -
#pragma mark Menu Table data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return number of historic runs
    return [runs count];
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSUInteger row = [indexPath row];
    
    GoalCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"GoalCell"
                                                              owner:self
                                                            options:nil]objectAtIndex:0];
    [cell setup];
    
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
    
}


#pragma mark - UI actions


- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)goalTapped:(id)sender {
    
    CreateGoalViewController  * vc = [[CreateGoalViewController alloc] initWithNibName:@"CreateGoal" bundle:nil];
    
    [self presentViewController:vc animated:true completion:nil];
    
}
@end
