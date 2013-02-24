//
//  GoalsViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray * runs;
}

@property (strong, nonatomic) IBOutlet UIButton *doneBut;
@property (strong, nonatomic) IBOutlet UIButton *goalButton;
@property (strong, nonatomic) IBOutlet UITableView *table;

- (IBAction)done:(id)sender;
- (IBAction)goalTapped:(id)sender;
@end
