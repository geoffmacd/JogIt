//
//  DatePickViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-08.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIDatePicker *datePick;
- (IBAction)dateChanged:(id)sender;
- (IBAction)donePressed:(id)sender;

@end


@protocol DatePickViewControllerDelegate <NSObject>

-(void)finishedWithDate:(NSDate *) date; 

@end
