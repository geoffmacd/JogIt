//
//  CreateGoalViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "CreateGoalViewController.h"
#import "EditGoalViewController.h"
#import "CreateGoalCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CreateGoalViewController ()

@end

@implementation CreateGoalViewController

@synthesize doneBut;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //set rounded corners on buttons
    [doneBut.layer setCornerRadius:8.0f];
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
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return number of  goals
    return 4;
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    CreateGoalCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"CreateGoalCell"
                                                      owner:self
                                                    options:nil]objectAtIndex:0];
    [cell setup:row];
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    return 64.0;
    
    
    
}

#pragma mark -
#pragma mark  Table delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditGoalViewController  * vc = [[EditGoalViewController alloc] initWithNibName:@"EditGoalViewController" bundle:nil];
    
    
    Goal *goal = [Goal alloc];
    [goal initWithType:[indexPath row] value:[NSNumber numberWithInt:0] start:[NSDate date] end:nil];
    
    [vc setGoal:goal];
    
    [self presentViewController:vc animated:true completion:nil];
}



#pragma mark -
#pragma mark  UI Actions

- (IBAction)doneTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
