//
//  DatePickViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-08.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "DatePickViewController.h"

@interface DatePickViewController ()

@end

@implementation DatePickViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateChanged:(id)sender {
}

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
