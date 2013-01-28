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



@implementation MenuViewController

@synthesize MenuTable;

- (IBAction)done:(UIStoryboardSegue *)segue {
    // Optional place to read data from closing controller
}

- (IBAction)settingsTapped:(id)sender
{
    [self performSegueWithIdentifier:@"SettingsSegue" sender:self];
    
}

#pragma mark -
#pragma mark Table view data source

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
#pragma mark Table view delegate

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

@end
