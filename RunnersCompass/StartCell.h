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
@property (strong, nonatomic) IBOutlet UIButton *addRunButton;
@property (strong, nonatomic) IBOutlet UIButton *justGoBut;
@property (strong, nonatomic) IBOutlet UIButton *distanceBut;
@property (strong, nonatomic) IBOutlet UIButton *paceBut;
@property (strong, nonatomic) IBOutlet UIButton *timeBut;
@property (strong, nonatomic) IBOutlet UIButton *caloriesBut;
@property (strong, nonatomic) IBOutlet UIButton *garbageBut;

//delegate
@property (weak, nonatomic) id <StartCellDelegate>delegate;

//instance variables
@property BOOL expanded;//for whether currently expanded
@property BOOL locked;//for whether currently expanded

//UI actions
- (IBAction)justGoUntapped:(id)sender;
- (IBAction)justGoTapped:(id)sender;
- (IBAction)distanceTapped:(id)sender;
- (IBAction)distanceUntapped:(id)sender;
- (IBAction)paceTapped:(id)sender;
- (IBAction)paceUntapped:(id)sender;
- (IBAction)timeUntapped:(id)sender;
- (IBAction)calorieUntapped:(id)sender;
- (IBAction)timeTapped:(id)sender;
- (IBAction)calorieTapped:(id)sender;
- (IBAction)addRunTapped:(id)sender;
- (IBAction)headerTapped:(id)sender;
- (IBAction)justGoTouched:(id)sender;
- (IBAction)distanceTouched:(id)sender;
- (IBAction)paceTouched:(id)sender;
- (IBAction)timeTouched:(id)sender;
- (IBAction)calorieTouched:(id)sender;


-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)setup;

@end

