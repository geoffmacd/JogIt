//
//  ChartCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-16.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "PRCell.h"

@implementation PRCell

@synthesize folderImage;
@synthesize statView;
@synthesize headerView;
@synthesize delegate;
@synthesize expanded;
@synthesize furthestTitle,furthestValue,fastestTitle,fastestValue;
@synthesize caloriesTitle,caloriesValue,longestTitle,longestValue;
@synthesize subtitleLabel,titleLabel;
@synthesize furthestUnit,fastestUnit,prefs;
@synthesize fastestDate,furthestDate,longestDate,calsDate;

#pragma mark - Lifecycle

-(void)setupWithFastest:(NSString*)fast fastDate:(NSDate*)fastDateObj furthest:(NSString*)furthest furthestDate:(NSDate*)furthestDateObj calories:(NSString*)cals calsDate:(NSDate*)calsDateObj longest:(NSString*)longest longestDate:(NSDate*)longestDateObj
{
    
    [statView setHidden:true];
    [AnimationUtil rotateImage:folderImage duration:0 curve:UIViewAnimationCurveEaseIn degrees:90];
    
    //set values
    [furthestValue setText:furthest];
    [fastestValue setText:fast];
    [caloriesValue setText:cals];
    [longestValue setText:longest];
    
    NSString * dateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:calendar];
    
    dateString = [dateFormatter stringFromDate:furthestDateObj];
    [furthestDate setText:dateString];
    dateString = [dateFormatter stringFromDate:fastDateObj];
    [fastestDate setText:dateString];
    dateString = [dateFormatter stringFromDate:calsDateObj];
    [calsDate setText:dateString];
    dateString = [dateFormatter stringFromDate:longestDateObj];
    [longestDate setText:dateString];
    
    //set units
    [furthestUnit setText:[prefs getDistanceUnit]];
    [fastestUnit setText:[prefs getPaceUnit]];
    
    //localized labels in IB
    [furthestTitle setText:NSLocalizedString(@"prcellfurthest", @"prcell furthest")];
    [fastestTitle setText:NSLocalizedString(@"prcellfastest", @"prcell fast")];
    [longestTitle setText:NSLocalizedString(@"prcelllongest", @"prcell long")];
    [caloriesTitle setText:NSLocalizedString(@"prcellcalories", @"prcell cals")];
    
    [titleLabel setText:NSLocalizedString(@"prcelltitle", @"prcell title")];
    [subtitleLabel setText:NSLocalizedString(@"prcellsubtitle", @"prcell subtitle")];
    
    
    [subtitleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [fastestTitle setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [furthestTitle setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [caloriesTitle setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [longestTitle setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [fastestValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [furthestValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [caloriesValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [longestValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [fastestUnit setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [furthestUnit setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [fastestDate setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [furthestDate setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [calsDate setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [longestDate setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:14.0f]];
}

-(void)setTimePeriod:(BOOL) toWeekly
{

}

- (IBAction)expandTapped:(id)sender {
}

- (IBAction)headerTapped:(id)sender {
    
    [self setExpand:!expanded withAnimation:true];
}

-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate
{
    expanded = open;
    
    NSTimeInterval time = animate ? folderRotationAnimationTime : 0.01f;
    
    if(expanded){
        
        [AnimationUtil rotateImage:folderImage duration:time curve:UIViewAnimationCurveEaseIn degrees:-90];
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:statView toOpen:true openTime:hierarchicalCellAnimationExpand closeTime:hierarchicalCellAnimationCollapse closeAnimation:UIViewAnimationOptionCurveEaseIn];
        }
        
    }else{
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:statView toOpen:false openTime:hierarchicalCellAnimationExpand closeTime:hierarchicalCellAnimationCollapse closeAnimation:UIViewAnimationOptionCurveEaseIn];
        }
        
        [AnimationUtil rotateImage:folderImage duration:time curve:UIViewAnimationCurveEaseIn degrees:90];
    }
    
    if(!animate)
    {
        [statView setHidden:!open];
    }
    
    [delegate cellDidChangeHeight:self];
}

-(CGFloat)getHeightRequired
{
    
    if(!expanded)
    {
        return headerView.frame.size.height;
    }else{
        return headerView.frame.size.height + statView.frame.size.height;
    }
}

@end
