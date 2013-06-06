//
//  HierarchicalButton.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "HierarchicalCell.h"

@implementation HierarchicalCell

@synthesize folderImage;
@synthesize thumbnailImage;
@synthesize headerLabel;
@synthesize expandedView;
@synthesize headerView;
@synthesize garbageBut;
@synthesize paceLabel,calLabel,calUnit,timeLabel,minUnit,paceUnit;
@synthesize manualEntryLabel;


@synthesize delegate;

@synthesize associatedRun;
@synthesize parent;
@synthesize expanded;
@synthesize type;
@synthesize deletionMode;
@synthesize swipeGesture;



-(void)setup
{
    [self reloadUnitLabels];
    
    //thumbnail or manual entry label
    if(associatedRun.eventType == EventTypeRun)
    {
        [manualEntryLabel setHidden:true];
        [thumbnailImage setHidden:false];
        
        [thumbnailImage setImage:associatedRun.thumbnail];
        [thumbnailImage.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        //[thumbnailImage.layer setBorderWidth: 1.0];
        //corners to make map not look so square
        [thumbnailImage.layer setCornerRadius:5.0f];
        [thumbnailImage.layer setMasksToBounds:YES];
    }
    else if(associatedRun.eventType == EventTypeManual)
    {
        [manualEntryLabel setText: NSLocalizedString(@"ManualRunButton", @"ManualRunButton")];
        [manualEntryLabel setHidden:false];
        [thumbnailImage setHidden:true];
        
        //default manual run thumbnail
        //[thumbnailImage setImage:[UIImage imageNamed:@"manualrunthumbnail"]];
    }
    
    //set UI style
    //set fonts
    [headerLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:16.0f]];
    [manualEntryLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:16.0f]];
    [timeLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0f]];
    [calLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0f]];
    [paceLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0f]];
    [paceUnit setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [calUnit setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [minUnit setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    
    //fix hack to ensure triangle is in correct orientation
    [folderImage setImage:[UIImage imageNamed:@"triangle.png"]];
    
    //set unexpanded
    deletionMode = false;
    [garbageBut setHidden:true];
    [expandedView setHidden:true];
    
    //setup swipe gesture
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedRight:)];
    //set right direction
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    //add to view
    [self addGestureRecognizer:swipeGesture];
    //prevent uiscrollview from overriding right swipe gesture
    [delegate updateGestureFailForCell:swipeGesture];
    
    //setup gestures
    UITapGestureRecognizer * headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTap:)];
    [headerTap setNumberOfTapsRequired:1];
    [headerTap setCancelsTouchesInView:true];
    //add to view
    [headerView addGestureRecognizer:headerTap];
    UITapGestureRecognizer * expandTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandViewTap:)];
    [expandTap setNumberOfTapsRequired:1];
    [expandTap setCancelsTouchesInView:true];
    //add to view
    [expandedView addGestureRecognizer:expandTap];
    
    
    //tells heirarchical cell to get out of deletion mode, sent by 4 things:: new runs, selected runs, tapping other cells and navigation to other screens
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetDeletionMode)
                                                 name:@"resetCellDeletionModeAfterTouch"
                                               object:nil];
    
    //tells cell to reload labels for mi/km units
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUnitLabels)
                                                 name:@"reloadUnitsNotification"
                                               object:nil];
    
}


-(void) setAssociated:(RunEvent*) event
{
    if(event)
    {
        associatedRun = event;
        
        [self setup];
    }
}

-(void)reloadUnitLabels
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:calendar];
    
    UserPrefs * prefs = [delegate getPrefs];
    NSString * distanceUnitText = [prefs getDistanceUnit];
    NSString * paceUnitText = [prefs getPaceUnit];
    BOOL metricUnit = [prefs.metric integerValue];
    BOOL showSpeed = [prefs.showSpeed boolValue];
    
    TTTOrdinalNumberFormatter *ordinalNumberFormatter = [[TTTOrdinalNumberFormatter alloc] init];
    [ordinalNumberFormatter setLocale:[NSLocale currentLocale]];
    [ordinalNumberFormatter setGrammaticalGender:TTTOrdinalNumberFormatterMaleGender];
    
    NSString * header = [NSString stringWithFormat:@"%.2f %@ • %@, %@", [RunEvent getDisplayDistance:associatedRun.distance withMetric:metricUnit],  distanceUnitText, [dateFormatter stringFromDate:associatedRun.date], [ordinalNumberFormatter stringFromNumber:[NSNumber numberWithInt:dayOfTheMonthFromDate(associatedRun.date)]]];
    [headerLabel setText:header];
    
    //Set units for localization/units
    [paceUnit setText:paceUnitText];
    [calUnit setText: NSLocalizedString(@"CalShortForm", @"Shortform for calories")];
    [minUnit setText: NSLocalizedString(@"TimeShort", @"Shortform units for time")];
    
    //Set values
    [paceLabel setText:[RunEvent getPaceString:associatedRun.avgPace withMetric:metricUnit showSpeed:showSpeed]];
    [timeLabel setText:[RunEvent getTimeString:associatedRun.time]];
    [calLabel setText:[NSString stringWithFormat:@"%.0f", associatedRun.calories]];
}


-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate
{
    expanded = open;
    NSTimeInterval time = animate ? folderRotationAnimationTime : 0.0f;
    
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


-(void)collapseAll
{
    //then collapse this
    if(expanded)
        [self setExpand:false withAnimation:false];
}

-(void)expandAll
{
    //then expand this
    
    if(!expanded)
        [self setExpand:true withAnimation:false];
}

-(void)resetDeletionMode
{
    //only if in deletion mode, get out of it
    if(deletionMode)
    {
        deletionMode = false;
        
        //remove button
        [UIView animateWithDuration:0.25f animations:^{
            [garbageBut setAlpha:0.0f];
            
        }   completion:^(BOOL finished){
            
            [garbageBut setHidden:true];
            
        }];
    }
    
}


- (IBAction)expandViewTap:(id)sender
{
    [delegate selectedRun:self];
}

- (IBAction)headerViewTap:(id)sender
{
    
    [self setExpand:!expanded withAnimation:true];
}

- (IBAction)cellSwipedRight:(id)sender {
    
    //bring up garbage can if not already up
    if(!deletionMode)
    {
        //both hide and alpha
        [garbageBut setAlpha:0.0f];
        [garbageBut setHidden:false];
        
        [UIView animateWithDuration:0.25f animations:^{
            [garbageBut setAlpha:1.0f];
            
        }   completion:^(BOOL finished){
            
            
            deletionMode = true;
            
        }];
        
    }
    else{
        //if already up bring down
        [self resetDeletionMode];
    }
    
}


- (IBAction)garbageTapped:(id)sender
{
    [delegate garbageTapped:sender];
}


@end
