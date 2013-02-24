//
//  CreateGoalViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataTest.h"

@interface CreateGoalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *doneBut;
@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)doneTapped:(id)sender;
@end
