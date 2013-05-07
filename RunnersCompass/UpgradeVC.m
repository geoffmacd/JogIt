//
//  CreateGoalViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "UpgradeVC.h"

@implementation UpgradeVC

@synthesize table,prefs,delegate;

static NSString * upgradeID = @"io.geoffmacdonald.jogit.upgrade";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //add 3
    cells = [[NSMutableArray alloc] initWithCapacity:4];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark -
#pragma mark predict Table data source


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0 || tableView != table)
        return nil;
    
    //deliver goalheadercell
    if(!header)
    {
        header = (UpgradeHeaderCell*) [[[NSBundle mainBundle]loadNibNamed:@"UpgradeHeaderCell"
                                                                       owner:self
                                                                     options:nil]objectAtIndex:0];
        
        //round corners
        [header setup];
    }
    
    return header;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!header)
    {
        header =  (UpgradeHeaderCell*) [[[NSBundle mainBundle]loadNibNamed:@"UpgradeHeaderCell"
                                                                        owner:self
                                                                      options:nil]objectAtIndex:0];
        //round corners
        [header setup];
        
    }
    
    //return height of header, does not change
    return header.frame.size.height;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    if(row >= [cells count]){
        UpgradeCell * cell  =  [[[NSBundle mainBundle]loadNibNamed:@"UpgradeCell"owner:self options:nil] objectAtIndex:0];
        
        [cells addObject:cell];
        
        [cell setDelegate:self];
        //set bullet points for cell
        //set image for cell
        
        switch(row)
        {
            case 0:
                [cell.titleLabel setText:NSLocalizedString(@"InAppGoal", "title for goal")];
                [cell.point1Label setText:NSLocalizedString(@"InAppGoal1", "bullet pt for goal")];
                [cell.point2Label setText:NSLocalizedString(@"InAppGoal2", "bullet pt for goal")];
                [cell.point3Label setText:NSLocalizedString(@"InAppGoal3", "bullet pt for goal")];
                [cell.fullImage setImage:[UIImage imageNamed:@"goalfull.png"]];
                break;
            case 1:
                [cell.titleLabel setText:NSLocalizedString(@"InAppPredict", "title for Predict")];
                [cell.point1Label setText:NSLocalizedString(@"InAppPredict1", "bullet pt for Predict")];
                [cell.point2Label setText:NSLocalizedString(@"InAppPredict2", "bullet pt for Predict")];
                [cell.point3Label setText:NSLocalizedString(@"InAppPredict3", "bullet pt for Predict")];
                [cell.fullImage setImage:[UIImage imageNamed:@"predictionfull.png"]];
                break;
            case 2:
                [cell.titleLabel setText:NSLocalizedString(@"InAppGhost", "title for Ghost")];
                [cell.point1Label setText:NSLocalizedString(@"InAppGhost1", "bullet pt for Ghost")];
                [cell.point2Label setText:NSLocalizedString(@"InAppGhost2", "bullet pt for Ghost")];
                [cell.point3Label setText:NSLocalizedString(@"InAppGhost3", "bullet pt for Ghost")];
                [cell.fullImage setImage:[UIImage imageNamed:@"ghostfull.png"]];
                break;
            case 3:
                [cell.titleLabel setText:NSLocalizedString(@"InAppMetric", "")];
                [cell.point1Label setText:NSLocalizedString(@"InAppMetric1", "")];
                [cell.point2Label setText:NSLocalizedString(@"InAppMetric2", "")];
                [cell.point3Label setText:NSLocalizedString(@"InAppMetric3", "")];
                [cell.fullImage setImage:[UIImage imageNamed:@"statsfull.png"]];
                break;
        }
        
        [cell setup];
        
        return cell;
    }
    else{
        
        
        UpgradeCell * curCell = [cells objectAtIndex:row];
        
        return curCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    NSUInteger row = [indexPath row];
    
    if(row < [cells count])
    {
        UpgradeCell * cell = [cells objectAtIndex:row];
        
        height = [cell getHeightRequired];
    }
    else{
        height = 110.0f;
    }
    
    return height;
}


#pragma mark -  ChartCellDelegate

-(void) cellDidChangeHeight:(id) sender
{
    //animate with row belows move down nicely
    [table beginUpdates];
    [table endUpdates];
    [table reloadData];
    
    //still need to animate hidden expandedView
    
    //if sender was last cell or second last, then scroll to show expanded view
    NSIndexPath *path = [table indexPathForCell:sender];
    [table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:true];
}

#pragma mark -
#pragma mark  UI Actions

- (IBAction)doneTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)upgradeTapped:(id)sender {
    
    //purchase in-app through IAPhelper
    
    //should only be 1 product, the upgrade
    SKProduct* product;
    
    for(SKProduct * p in [IAPShare sharedHelper].iap.products)
    {
        if([p.productIdentifier isEqualToString:upgradeID])
            product = p;
        
    }
    
    if(product)
    {
        
        [[IAPShare sharedHelper].iap buyProduct:product
                                   onCompletion:^(SKPaymentTransaction* trans){
                                       
                                       
                                       
                                       //NSLog(@"Purchased, Thank You");
                                       
                                       prefs.purchased = [NSNumber numberWithBool:true];
                                       [delegate didPurchase];
                                       
                                       //give nottification to update settings on app delegate
                                       [[NSNotificationCenter defaultCenter]
                                        postNotificationName:@"settingsChangedNotification"
                                        object:prefs];
                                       
                                       //just dismiss user cancel
                                       [self dismissViewControllerAnimated:true completion:nil];
                                       
                                   }
                                         OnFail:^(SKPaymentTransaction* trans) {
                                             
                                             //present fail notification
                                             StandardNotifyVC * vc = [[StandardNotifyVC alloc] initWithNibName:@"StandardNotify" bundle:nil];
                                             [vc.view setBackgroundColor:[Util redColour]];
                                             [vc.view.layer setCornerRadius:5.0f];
                                             [vc.titleLabel setText:NSLocalizedString(@"SettingsPurchaseFail","purchase fail title")];
                                             [vc.updateLabel setText:@""];
                                             
                                             [self presentPopupViewController:vc animationType:MJPopupViewAnimationSlideTopBottom];
                                             
                                             //NSLog(@"Error");
                                         }];
    }
    else
    {
        //did not get product yet
        
        //present fail notification
        StandardNotifyVC * vc = [[StandardNotifyVC alloc] initWithNibName:@"StandardNotify" bundle:nil];
        [vc.view setBackgroundColor:[Util redColour]];
        [vc.view.layer setCornerRadius:5.0f];
        [vc.titleLabel setText:NSLocalizedString(@"SettingsPurchaseFail","purchase fail title")];
        [vc.updateLabel setText:@""];
        
        [self presentPopupViewController:vc animationType:MJPopupViewAnimationSlideTopBottom];
    }
    
}


@end
