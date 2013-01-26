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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [runs count];
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([indexPath row] >= [cells count])
    {
        HierarchicalCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"HierarchicalCell"
                                                 owner:self
                                               options:nil]objectAtIndex:0];
        NSUInteger rows = [indexPath row];
        [cell setAssociated:[runs objectAtIndex:rows]];
        [cell setDelegate:self];
        
        [cells addObject:cell];
        
        return cell;
    }
    else{
        
        NSUInteger row = [indexPath row];
        
        HierarchicalCell * curCell = [cells objectAtIndex:row];
        
        return curCell;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([indexPath row] > [runs count])
        return 0.0f;
    
    CGFloat height;
    NSUInteger row = [indexPath row];
    if([indexPath row] < [cells count])
    {
        HierarchicalCell * cell = [cells objectAtIndex:row];
    
        height = [cell getHeightRequired];
    }
    else{
        height = 45.0f;
    }
    
    
    return height;
    
    
}



#pragma mark -
#pragma mark Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if([indexPath row] > [runs count])
        return;
    
    
    NSUInteger row = [indexPath row];
    
    HierarchicalCell * cell = [cells objectAtIndex:row];
    
    if(!cell.expanded)
        [cell setExpand:true withAnimation:true];
    
}



-(void) cellDidChangeHeight
{
    //animate with row belows move down nicely
    [MenuTable beginUpdates];
    [MenuTable endUpdates];
    
    //still need to animate hidden expandedView
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    runs = [[NSMutableArray alloc] initWithCapacity:3];
    cells = [[NSMutableArray alloc] initWithCapacity:3];
    
    RunMap * map = [RunMap alloc];
    
    [map setThumbnail:[UIImage imageNamed:@"map.JPG"]];
    
     for(NSInteger i=0;i <3; i++)
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

@end
