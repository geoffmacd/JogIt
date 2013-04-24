//
//  CreateGoalHeaderCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "UpgradeHeaderCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation UpgradeHeaderCell

@synthesize doneBut,upgradeBut;

-(void) setup
{
    
    //set rounded corners on button
    [doneBut.layer setCornerRadius:8.0f];
    [doneBut.layer setMasksToBounds:true];
    
    [upgradeBut.layer setCornerRadius:8.0f];
    [upgradeBut.layer setMasksToBounds:true];
    
    //localized buttons in IB
    [doneBut setTitle:NSLocalizedString(@"CancelWord", @"cancel word ") forState:UIControlStateNormal];
    
    //get price of app and append to text
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         NSString * upgradeText = NSLocalizedString(@"UpgradeButton", @"upgrade button");
         SKProduct * upgrade =  [response.products lastObject];
         NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
         [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
         [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
         [numberFormatter setLocale:upgrade.priceLocale];
         NSString *formattedPrice = [numberFormatter stringFromNumber:upgrade.price];
         if(formattedPrice)
         {
             upgradeText = [upgradeText stringByAppendingString:formattedPrice];
         }
         [upgradeBut setTitle:upgradeText forState:UIControlStateNormal];
         
     }];
    
}


@end
