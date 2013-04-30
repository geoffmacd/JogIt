//
//  HierarchicalButton.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "DateCell.h"

@implementation DateCell

@synthesize folderImage;
@synthesize headerLabel;
@synthesize expandedView;
@synthesize headerView;
@synthesize distanceLabel,distanceValue,paceLabel,paceValue,runsLabel,runsValue;
@synthesize table;

@synthesize delegate;

@synthesize runs;
@synthesize expanded;
@synthesize numRuns,totalDistance,avgPace;


static NSString * cellID = @"HierarchicalCellPrototype";

-(void)setup
{
    
    [table registerClass:[HierarchicalCell class] forCellReuseIdentifier:cellID];
    UINib * nib = [UINib nibWithNibName:@"HierarchicalCell" bundle:[NSBundle mainBundle]] ;
    [table registerNib:nib forCellReuseIdentifier:cellID];
    
    if([runs count])
    {
    
        //runs should be loaded by now
        [self getPeriodTotals];
    
        [self reloadUnitLabels];
    }
    
    
    cells = [[NSMutableArray alloc] initWithCapacity:[runs count]];// 3 runs
    
    //set table size
    CGFloat tableHeight = [runs count] * 48; //48 each
    CGRect orgTableFrame = table.frame;
    CGRect newFrame = orgTableFrame;
    newFrame.size.height = tableHeight;
    [table setFrame:newFrame];
    [expandedView setFrame:newFrame];
    
    CGRect orgBounds = self.frame;
    CGRect newBounds = orgBounds;
    newBounds.size.height = tableHeight + 64;
    [self setBounds:newBounds];
     
    
    
    //set UI style
    //set red colour
    [headerView setBackgroundColor:[Util cellRedColour]];
    
    //fix hack to ensure triangle is in correct orientation
    [folderImage setImage:[UIImage imageNamed:@"triangle.png"]];
    
    //set unexpanded
    [self setExpand:false withAnimation:false];
    [expandedView setHidden:true];
    
    //setup gestures
    UITapGestureRecognizer * headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTap:)];
    [headerTap setNumberOfTapsRequired:1];
    [headerTap setCancelsTouchesInView:true];
    //add to view
    [headerView addGestureRecognizer:headerTap];

    
    //will reload units for distance, pace, etc
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUnitLabels)
                                                 name:@"reloadUnitsNotification"
                                               object:nil];
    
    
}
     
     
-(void)getPeriodTotals
{
    CGFloat totalPace = 0;
    avgPace = 0;
    totalDistance = 0;
    numRuns = 0;
    
    for(RunEvent * oldRun in runs)
    {
        numRuns++;
        
        totalDistance += oldRun.distance;
        totalPace += oldRun.avgPace;
    }
    if(numRuns > 0)
        avgPace = totalPace / numRuns;
    else
        avgPace = 0.0;
}


-(void)reloadUnitLabels
{
    UserPrefs * prefs = [delegate getPrefs];
    BOOL isMetric = [prefs.metric integerValue];
    BOOL showSpeed = [prefs.showSpeed boolValue];
    
    NSString * header;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    RunEvent * firstRun = [runs objectAtIndex:0];
    if([[prefs weekly] boolValue])
    {
        
        [formatter setDateFormat:@"MMMM"];
        header = [formatter stringFromDate:firstRun.date];
    }
    else
    {
        [formatter setDateFormat:@"WWWW"];
        header = [formatter stringFromDate:firstRun.date];
    }
    
    [headerLabel setText:header];
    
    //set values
    [paceValue setText:[RunEvent getPaceString:avgPace withMetric:isMetric showSpeed:showSpeed]];
    CGFloat displayDistance = [RunEvent getDisplayDistance:totalDistance withMetric:isMetric];
    [distanceValue setText:[NSString stringWithFormat:@"%.1f", displayDistance]];
    [runsValue setText:[NSString stringWithFormat:@"%d", numRuns]];
}


-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate
{
    expanded = open;
    NSTimeInterval time = animate ? folderRotationAnimationTime : 0.01f;
    
    if(expanded){
        
        [AnimationUtil rotateImage:folderImage duration:time
                    curve:UIViewAnimationCurveEaseIn degrees:90];
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:expandedView toOpen:true];
            
        }
        
    }else{
        
        [AnimationUtil rotateImage:folderImage duration:time
                             curve:UIViewAnimationCurveEaseIn degrees:0];
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:expandedView toOpen:false];
            
        }
    }
    
    if(!animate)
    {
        [expandedView setHidden:!open];
    }
    
    if(delegate)
        [delegate cellDidChangeHeight:self];
    
}


-(CGFloat)getHeightRequired
{
    
    if(!expanded)
    {
        return headerView.frame.size.height;
    }else{
        return headerView.frame.size.height + expandedView.frame.size.height;
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

    //return number of runs for this period
    return [runs count];
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    
    if(row >= [cells count]){
        
        HierarchicalCell * cell = (HierarchicalCell * )[tableView dequeueReusableCellWithIdentifier:cellID];
        
        [cells addObject:cell];
        [cell setDelegate:self];
        [cell setAssociated:[runs objectAtIndex:row]];
        
        return cell;
    }
    else{
        
        HierarchicalCell * curCell = [cells objectAtIndex:row];
        
        return curCell;
    }
}

#pragma mark -
#pragma mark Table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    NSUInteger row = [indexPath row];
    
    if(row >= [cells count]){
        
        height = 48.0f;
    }
    else{
        
        HierarchicalCell * cell = [cells objectAtIndex:row];
        
        height = [cell getHeightRequired];
    }
    
    return height;
}

#pragma mark -
#pragma mark HierarchicalCellDelegate

-(void) cellDidChangeHeight:(id) sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCellDeletionModeAfterTouch"
                                                        object:nil];
    
    //animate with row belows move down nicely
    [table beginUpdates];
    [table endUpdates];
    [table reloadData];//needed to have user interaction on start cell if this is expanded, also removes white line issue
    
    
    
    //set table size
    CGFloat tableHeight = [runs count] * 48; //48 each
    CGRect orgTableFrame = table.frame;
    CGRect newFrame = orgTableFrame;
    newFrame.size.height = tableHeight;
    [table setFrame:newFrame];
    [expandedView setFrame:newFrame];
    
    CGRect orgBounds = self.frame;
    CGRect newBounds = orgBounds;
    newBounds.size.height = tableHeight + 64;
    [self setBounds:newBounds];
    
    [delegate cellDidChangeHeight:self];
}

-(void)selectedRun:(id)sender
{
    [delegate selectedRun:sender];
}

-(void)updateGestureFailForCell:(UIGestureRecognizer*)cellGesture
{
    [delegate updateGestureFailForCell:cellGesture];
}

-(UserPrefs*)getPrefs
{
    return [delegate getPrefs];
}

#pragma mark -
#pragma mark IB actions


- (IBAction)headerViewTap:(id)sender
{
    
    [self setExpand:!expanded withAnimation:true];
}




@end
