//
//  HierarchicalButton.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RunEvent.h"




@protocol StartCellDelegate <NSObject>

-(void)cellDidChangeHeight:(id) sender;
-(void)selectedNewRun:(RunEvent *) run;
-(void)selectedRunInProgress:(BOOL)shouldDiscard;

@end

@interface StartCell : UITableViewCell


//UI connections
@property (weak, nonatomic) IBOutlet UIView *expandedView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *folderImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *addRunButton;
@property (weak, nonatomic) IBOutlet UIButton *justGoBut;
@property (weak, nonatomic) IBOutlet UIButton *distanceBut;
@property (weak, nonatomic) IBOutlet UIButton *paceBut;
@property (weak, nonatomic) IBOutlet UIButton *timeBut;
@property (weak, nonatomic) IBOutlet UIButton *caloriesBut;
@property (weak, nonatomic) IBOutlet UIButton *garbageBut;
@property (weak, nonatomic) IBOutlet UIButton *manualBut;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//delegate
@property (weak, nonatomic) id <StartCellDelegate>delegate;

//instance variables
@property BOOL expanded;//for whether currently expanded
@property BOOL locked;//for whether currently expanded

//UI actions
- (IBAction)headerTapped:(id)sender;
- (IBAction)addRunTapped:(id)sender;
- (IBAction)justGoUntapped:(id)sender;
- (IBAction)justGoTapped:(id)sender;
- (IBAction)justGoTouched:(id)sender;
- (IBAction)distanceTapped:(id)sender;
- (IBAction)distanceUntapped:(id)sender;
- (IBAction)distanceTouched:(id)sender;
- (IBAction)paceTapped:(id)sender;
- (IBAction)paceUntapped:(id)sender;
- (IBAction)paceTouched:(id)sender;
- (IBAction)timeUntapped:(id)sender;
- (IBAction)timeTapped:(id)sender;
- (IBAction)timeTouched:(id)sender;
- (IBAction)calorieTouched:(id)sender;
- (IBAction)calorieTapped:(id)sender;
- (IBAction)calorieUntapped:(id)sender;
- (IBAction)manualTapped:(id)sender;
- (IBAction)manualUntapped:(id)sender;
- (IBAction)manualTouched:(id)sender;


-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)setup;

@end

