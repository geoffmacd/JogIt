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

@synthesize periodStart;
@synthesize runs,locked;
@synthesize expanded;
@synthesize indexForColor;
@synthesize numRuns,totalDistance,avgPace;


static NSString * cellID = @"HierarchicalCellPrototype";

-(void)setup
{
    //all runs configured
    
    [table registerClass:[HierarchicalCell class] forCellReuseIdentifier:cellID];
    UINib * nib = [UINib nibWithNibName:@"HierarchicalCell" bundle:[NSBundle mainBundle]] ;
    [table registerNib:nib forCellReuseIdentifier:cellID];
    
    //runs should be loaded by now
    //no effect if 0 runs
    [self getPeriodTotals];
    
    [self reloadUnitLabels];
    
    cells = [[NSMutableArray alloc] initWithCapacity:[runs count]];
    
    //set table size
    [self setCorrectFrames];
    
    //set UI style
    //set red colour
    
    //set color according to index
    [headerView setBackgroundColor:[Util flatColorForCell:indexForColor]];
    //[self.layer setCornerRadius:15.0f];
    //[self.layer setMasksToBounds:true];
    //[headerView setBackgroundColor:[Util cellRedColour]];
    
    //fix hack to ensure triangle is in correct orientation
    [folderImage setImage:[UIImage imageNamed:@"triangle.png"]];
    
    //set unexpanded
    [self setExpand:false withAnimation:false];
    //[expandedView setHidden:true];
    
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
    
    //don't execute if nothing is here
    if(![runs count])
        return;
    
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
    TTTOrdinalNumberFormatter *ordinalNumberFormatter = [[TTTOrdinalNumberFormatter alloc] init];
    [ordinalNumberFormatter setLocale:[NSLocale currentLocale]];
    [ordinalNumberFormatter setGrammaticalGender:TTTOrdinalNumberFormatterMaleGender];
    if([[prefs weekly] boolValue])
    {
        NSDate *endPeriod = shiftDateByXdays(periodStart, 7);
        [formatter setDateFormat:@"MMMM"];
        header = [NSString stringWithFormat:@"%@ %@ - %@",[formatter stringFromDate:periodStart], [ordinalNumberFormatter stringFromNumber:[NSNumber numberWithInt:dayOfTheMonthFromDate(periodStart)]], [ordinalNumberFormatter stringFromNumber:[NSNumber numberWithInt:dayOfTheMonthFromDate(endPeriod)]]];
    }
    else
    {
        [formatter setDateFormat:@"MMMM"];
        header = [formatter stringFromDate:periodStart];
    }
    
    [headerLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:18.0f]];
    [headerLabel setText:header];
    
    if([runs count] == 0)
    {
        //disable expand and hide folder image
        [folderImage setHidden:true];
        locked = true;
    }
    else
    {
        [folderImage setHidden:false];
        locked = false;
    }
    
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

-(void)collapseAll:(NSInteger)state
{
    
    if(state == 0)
    {
        if(expanded)
            [self headerViewTap:nil];
    }
    
    if(state == 1)
    {
        for(HierarchicalCell * cell in cells)
        {
            [cell collapseAll];
        }
    }
    
}

-(void)expandAll:(NSInteger)state
{
    if(state == 1)
    {
        if(!expanded)
            [self headerViewTap:nil];
    }
    
    if(state == 2)
    {
        for(HierarchicalCell * cell in cells)
        {
            [cell expandAll];
        }
    }
}

-(void) setCorrectFrames
{
    
    //set table size
    CGFloat tableHeight = [runs count] * 48; //48 each,unexpanded
    
    for(HierarchicalCell * cell in cells)
    {
        if(cell.expanded)
            tableHeight += 76;
    }
    
    
    CGRect newFrame = self.frame;
    newFrame.size.height = tableHeight + 64;
    [self setFrame:newFrame];
    CGRect orgTableFrame = expandedView.frame;
    newFrame = orgTableFrame;
    newFrame.size.height = tableHeight;
    [expandedView setFrame:newFrame];
    //newFrame.origin.y = 64;
    newFrame.origin.y = 0;
    [table setFrame:newFrame];
    
    //contact menu to tell it size has changed
    [delegate cellDidChangeHeight:self];

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
        [cell.headerView setBackgroundColor:[Util flatColorForCell:indexForColor]];
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

-(void)cellDidChangeHeight:(id) sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCellDeletionModeAfterTouch"
                                                        object:nil];
    
    //animate with row belows move down nicely
    [table beginUpdates];
    [table endUpdates];
    [table reloadData];//needed to have user interaction on start cell if this is expanded, also removes white line issue
    
    
    HierarchicalCell * senderCell = sender;
    
    BOOL didExpand = senderCell.expanded;
    
    //animate date cell
    CGRect expandFrame = expandedView.frame;
    CGRect tableFrame = table.frame;
    CGRect cellFrame = self.frame;
    
    if(didExpand)
    {
        
        cellFrame.size.height += 124;
        expandFrame.size.height += 124;
        tableFrame.size.height += 124;
        
        [UIView animateWithDuration:cellDropAnimationTime
                         animations:^{
                             [table setFrame:tableFrame];
                             [expandedView setFrame:expandFrame];
                             [self setFrame:cellFrame];
                         }
                         completion:^(BOOL finished) {
                         }];
    }
    else
    {
        
        cellFrame.size.height -= 124;
        expandFrame.size.height -= 124;
        tableFrame.size.height -= 124;
        
        [UIView animateWithDuration:cellDropAnimationTime
                         animations:^{
                             [table setFrame:tableFrame];
                             [expandedView setFrame:expandFrame];
                             [self setFrame:cellFrame];
                         }
                         completion:^(BOOL finished) {
                         }];
    }

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

- (void)garbageTapped:(id)sender {
    
    //remove cell
    UIButton * cellButtonTapped = sender;
    NSUInteger indexOfCell = 10000;
    
    //must find owner of the button that this was tapped by
    for(int i = 0; i < [cells count]; i++)
    {
        if([cellButtonTapped isDescendantOfView:[cells objectAtIndex:i]])
        {
            indexOfCell = i;
            break;
        }
    }
    
    if(indexOfCell != 10000)
    {
        HierarchicalCell * cellToDelete = [cells objectAtIndex:indexOfCell];
        
        //gauranteed to be the correct row number since the array is reloaded along with the table
        NSIndexPath * indexToDelete = [NSIndexPath indexPathForRow:indexOfCell inSection:0];
        
        NSArray *arrayToDeleteCells = [NSArray arrayWithObject:indexToDelete];
        
        RunEvent * runDeleting = [cellToDelete associatedRun];
        
        
        //delete from db
        RunRecord * recordToDelete = [RunRecord MR_findFirstByAttribute:@"date" withValue:runDeleting.date];
        //remove both run and cell, run is most necessary
        [runs removeObject:runDeleting];
        if(recordToDelete)
        {
            [recordToDelete MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
        [cells removeObjectAtIndex:indexOfCell];
        
        //commit and reload table here
        [table deleteRowsAtIndexPaths:arrayToDeleteCells withRowAnimation:UITableViewRowAnimationLeft];
        
        //reload
        [table reloadData];
        
        [delegate didDeleteRun];
        
        [self setCorrectFrames];
        
        [self getPeriodTotals];
        [self reloadUnitLabels];
        
    }
    else{
        NSLog(@"Cant find cell to delete");
    }
}

#pragma mark -
#pragma mark IB actions


- (IBAction)headerViewTap:(id)sender
{
    if(locked)
    {
        //only allow to slide in when locked
        if(expanded)
            [self setExpand:!expanded withAnimation:true];
    }
    else
        [self setExpand:!expanded withAnimation:true];
}


@end
