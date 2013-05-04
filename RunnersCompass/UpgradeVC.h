//
//  CreateGoalViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UpgradeCell.h"
#import "UpgradeHeaderCell.h"
#import "IAPShare.h"
#import "StandardNotifyVC.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "UserPrefs.h"
#import "Util.h"

@protocol UpgradeVCDelegate <NSObject>

-(void)didPurchase;

@end

@interface UpgradeVC: UITableViewController<UITableViewDataSource,UITableViewDelegate,UpgradeCellDelegate>
{
    UpgradeHeaderCell * header;
    NSMutableArray * cells;
}


@property (weak)  IBOutlet UITableView *table;
@property (weak)  UserPrefs *prefs;

//delegate
@property id <UpgradeVCDelegate>delegate;


- (IBAction)doneTapped:(id)sender;
- (IBAction)upgradeTapped:(id)sender;

@end
