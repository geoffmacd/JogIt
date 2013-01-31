//
//  MenuViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HierarchicalCell.h"
#import "StartCell.h"
#import "JSSlidingViewController.h"
#import "Logger.h"

@protocol MenuViewControllerDelegate;


@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HierarchicalCellDelegate,StartCellDelegate, JSSlidingViewControllerDelegate, LoggerViewControllerDelegate>
{
    NSMutableArray * runs;
    NSMutableArray * cells;
    StartCell * start;
    
}

@property (weak, nonatomic) IBOutlet UITableView *MenuTable;
@property (strong, nonatomic) IBOutlet UIImageView *pauseImage;



@end
