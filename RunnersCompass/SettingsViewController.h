//
//  Settings.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTableCell.h"
#import "DatePickViewController.h"

@interface SettingsViewController : UITableViewController<UITextFieldDelegate,DatePickViewControllerDelegate>
{
    // referring to our xib-based UITableViewCell ('IndividualSubviewsBasedApplicationCell')
	UINib *cellNib;
    
	EditTableCell *tmpCell;
}

@property (nonatomic, retain) IBOutlet EditTableCell *tmpCell;

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, retain) UINib *cellNib;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)changedDate:(id)sender;

@end
