//
//  MenuViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import "Menu.h"
#import "HierarchicalCell.h"
#import "Constants.h"
#import "RunEvent.h"



@implementation MenuViewController

@synthesize MenuTable;


#pragma mark -
#pragma mark Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HierarchicalCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HierarchicalCell"
                                                          owner:self
                                                        options:nil]objectAtIndex:0];
    
    [cell setAssociated:[runs objectAtIndex:0]];
    
    
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



- (void) loadTable
{
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    runs = [[NSMutableArray alloc] initWithCapacity:3];
      
    RunMap * map = [RunMap alloc];
    
    [map setThumbnail:[UIImage imageNamed:@"map.JPG"]];
    
     for(NSInteger i=0;i <3; i++)
     {
         
         RunEvent * run = [[RunEvent alloc] initWithName:@"10.5 Km  *  January 23rd, 2013" date:[NSDate date]];
         
         [run setMap:map];
         
         [runs addObject:run];
         
     }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
