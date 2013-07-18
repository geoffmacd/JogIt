//
//  PerformanceViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>
#import "ChartCell.h"
#import "Analysis.h"
#import "DataTest.h"

@interface PredictorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ChartCellDelegate>
{
    NSMutableArray * cells;
    Analysis * analysis;
    
}

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, assign) BOOL weekly;

- (IBAction)doneTapped:(id)sender;
- (IBAction)weeklyTapped:(id)sender;
- (IBAction)monthlyTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *weeklyBut;
@property (strong, nonatomic) IBOutlet UIButton *monthlyBut;
@property (strong, nonatomic) IBOutlet UIButton *doneBut;
@end
