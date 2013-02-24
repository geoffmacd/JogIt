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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set rounded corners on buttons
    
    //set rounded corners on buttons
    [doneBut.layer setCornerRadius:8.0f];
        
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
    
    CreateGoalViewController  * vc = [[CreateGoalViewController alloc] initWithNibName:@"CreateGoalViewController" bundle:nil];
    
    [self presentViewController:vc animated:true completion:nil];
    
}
@end
