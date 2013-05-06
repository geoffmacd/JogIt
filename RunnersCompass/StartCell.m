//
//  HierarchicalButton.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "StartCell.h"
#import "AnimationUtil.h"

@implementation StartCell

@synthesize folderImage;
@synthesize headerLabel;
@synthesize expandedView;
@synthesize headerView;
@synthesize delegate;
@synthesize addRunButton;
@synthesize timeBut,paceBut,caloriesBut,justGoBut,distanceBut;
@synthesize expanded,locked,garbageBut,timeLabel,manualBut,recordImage;

-(void)setup
{

    locked = false;
    
    expanded = false;
    [expandedView setHidden:true];
    
    [headerLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:16.0f]];
    [headerLabel setText:NSLocalizedString(@"StartRunTitle", @"Title for start cell")];
    //[headerLabel setText:@""];
    
    [timeLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0f]];
    
    //localized buttons in IB
    [timeBut setTitle:NSLocalizedString(@"TimeRunTargetButton", @"TimeRunTargetButton") forState:UIControlStateNormal];
    [justGoBut setTitle:NSLocalizedString(@"JustGoTargetButton", @"JustGoTargetButton") forState:UIControlStateNormal];
    [caloriesBut setTitle:NSLocalizedString(@"CaloriesRunTargetButton", @"CaloriesRunTargetButton") forState:UIControlStateNormal];
    [paceBut setTitle:NSLocalizedString(@"PaceRunTargetButton", @"PaceRunTargetButton") forState:UIControlStateNormal];
    [distanceBut setTitle:NSLocalizedString(@"DistanceRunTargetButton", @"DistanceRunTargetButton") forState:UIControlStateNormal];
    [manualBut setTitle:NSLocalizedString(@"ManualRunButton", @"ManualRunButton") forState:UIControlStateNormal];
    
    //set custom font
    [timeBut.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13.0f]];
    [caloriesBut.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13.0f]];
    [distanceBut.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13.0f]];
    [manualBut.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13.0f]];
    [paceBut.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13.0f]];
    [justGoBut.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13.0f]];
    
    //time label
    [timeLabel setText:@""];
    [timeLabel setHidden:true];
    
    
    /*
    //for splash
    [addRunButton setHidden:true];
    [headerLabel setHidden:true];
    [folderImage setHidden:true];
     */
}


-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate
{
    
    expanded = open;
    NSTimeInterval time = animate ? folderRotationAnimationTime : 0.01f;
    
    if(expanded){
        
        
        [AnimationUtil rotateImage:folderImage duration:time curve:UIViewAnimationCurveEaseIn degrees:90];
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:expandedView toOpen:true];
        
        }
        
        
    }else{
        
        [AnimationUtil rotateImage:folderImage duration:time curve:UIViewAnimationCurveEaseIn degrees:0];
        
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

- (IBAction)headerTapped:(id)sender {
    
    //custom lock property for start cell
    if(!locked)
        [self setExpand:!expanded withAnimation:true];
    else
        [delegate selectedRunInProgress:false];     //do not want to discard run if header is hit
    
}

- (IBAction)justGoTouched:(id)sender {
    [justGoBut.layer setCornerRadius:5.0f];
    [justGoBut.layer setMasksToBounds:true];
    
    [justGoBut.layer setBorderWidth:0.5f];
    [justGoBut.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (IBAction)distanceTouched:(id)sender {
    [distanceBut.layer setCornerRadius:5.0f];
    [distanceBut.layer setMasksToBounds:true];
    
    [distanceBut.layer setBorderWidth:0.5f];
    [distanceBut.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (IBAction)paceTouched:(id)sender {
    [paceBut.layer setCornerRadius:5.0f];
    [paceBut.layer setMasksToBounds:true];
    
    [paceBut.layer setBorderWidth:0.5f];
    [paceBut.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (IBAction)timeTouched:(id)sender {
    [timeBut.layer setCornerRadius:5.0f];
    [timeBut.layer setMasksToBounds:true];
    
    [timeBut.layer setBorderWidth:0.5f];
    [timeBut.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (IBAction)calorieTouched:(id)sender {
    [caloriesBut.layer setCornerRadius:5.0f];
    [caloriesBut.layer setMasksToBounds:true];
    
    [caloriesBut.layer setBorderWidth:0.5f];
    [caloriesBut.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (IBAction)manualTouched:(id)sender
{
    [manualBut.layer setCornerRadius:5.0f];
    [manualBut.layer setMasksToBounds:true];
    
    [manualBut.layer setBorderWidth:0.5f];
    [manualBut.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (IBAction)addRunTapped:(id)sender {
    
    //custom lock property for start cell
    if(!locked)
        [self setExpand:!expanded withAnimation:true];
    else
        [delegate selectedRunInProgress:true];
}



- (IBAction)paceTapped:(id)sender {
    [paceBut.layer setBorderWidth:0.0f];
}

- (IBAction)paceUntapped:(id)sender {
    [paceBut.layer setBorderWidth:0.0f];
}

- (IBAction)timeUntapped:(id)sender {
    [timeBut.layer setBorderWidth:0.0f];
}

- (IBAction)timeTapped:(id)sender {
    [timeBut.layer setBorderWidth:0.0f];
}

- (IBAction)calorieUntapped:(id)sender {
    [caloriesBut.layer setBorderWidth:0.0f];
}
- (IBAction)calorieTapped:(id)sender {
    [caloriesBut.layer setBorderWidth:0.0f];
}

- (IBAction)justGoUntapped:(id)sender {
    [justGoBut.layer setBorderWidth:0.0f];
}

- (IBAction)justGoTapped:(id)sender {
    [justGoBut.layer setBorderWidth:0.0f];
}

- (IBAction)distanceTapped:(id)sender {
    [distanceBut.layer setBorderWidth:0.0f];
}

- (IBAction)distanceUntapped:(id)sender {
    [distanceBut.layer setBorderWidth:0.0f];
}

- (IBAction)manualTapped:(id)sender
{
    [manualBut.layer setBorderWidth:0.0f];
}

- (IBAction)manualUntapped:(id)sender
{
    [manualBut.layer setBorderWidth:0.0f];
}

@end
