//
//  HierarchicalButton.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunEvent.h"




@protocol StartCellDelegate <NSObject>

-(void)cellDidChangeHeight:(id) sender;
-(void)selectedNewRun:(RunEvent *) run;

@end

@interface StartCell : UITableViewCell


//UI connections
@property (weak, nonatomic) IBOutlet UIView *expandedView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *folderImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

- (IBAction)expandTapped:(id)sender;
- (IBAction)headerTapped:(id)sender;
//delegate
@property (weak, nonatomic) id <StartCellDelegate>delegate;

//instance variables
@property BOOL expanded;//for whether currently expanded

-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
- (void)handleStartTap:(UITapGestureRecognizer *)gestureRecognizer;
-(void)setup;
- (IBAction)justGoTapped:(id)sender;
- (IBAction)distanceTapped:(id)sender;
- (IBAction)paceTapped:(id)sender;
- (IBAction)timeTapped:(id)sender;
- (IBAction)calorieTapped:(id)sender;

@end

