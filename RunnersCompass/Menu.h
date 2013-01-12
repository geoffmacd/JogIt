//
//  MenuViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate<NSObject>

@end


@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *MenuTable;

@end
