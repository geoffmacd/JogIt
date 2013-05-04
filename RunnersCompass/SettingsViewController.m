//
//  Settings.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController()

@end

@implementation SettingsViewController

@synthesize formModel,prefsToChange,oldMetric,oldShowSpeed,restoreAvailable,oldGrouping;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView
                                        navigationController:self.navigationController];
    
    oldMetric = [prefsToChange.metric boolValue];
    oldShowSpeed = [prefsToChange.showSpeed boolValue];
    oldGrouping = [prefsToChange.weekly boolValue];
    restoreAvailable = ![prefsToChange.purchased boolValue];
    
    [FKFormMapping mappingForClass:[UserPrefs class] block:^(FKFormMapping *formMapping) {
        [formMapping sectionWithTitle:@"" identifier:@"saveButton"];
        
        [formMapping buttonSave:NSLocalizedString(@"DoneButton", @"done button")  handler:^{
            NSLog(@"save pressed");
            
            //send out notification if units have changed
            if(oldMetric != [prefsToChange.metric boolValue] || oldShowSpeed != [prefsToChange.showSpeed boolValue])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadUnitsNotification"
                                                                object:nil];
            }
            
            //send out notification if units have changed
            if(oldGrouping != [prefsToChange.weekly boolValue])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"groupingChangedNotification"
                                                                    object:nil];
            }
            
            //give nottification to update settings on app delegate
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"settingsChangedNotification"
             object:prefsToChange];
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        /*
        
        [formMapping sectionWithTitle:NSLocalizedString(@"SettingsPersonalHeader", @"personal header in settings")   identifier:@"info"];
        
        [formMapping mapAttribute:@"fullname" title:NSLocalizedString(@"SettingsFullName", @"full name settings")  type:FKFormAttributeMappingTypeText];
        [formMapping mappingForAttribute:@"birthdate"
                                   title:NSLocalizedString(@"SettingsBirth", @"birth date in settings") 
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];
         */
        
        
        [formMapping sectionWithTitle:NSLocalizedString(@"SettingsOrganizeHeader", @"organize header in settings")  identifier:@"Organize"];
        [formMapping mapAttribute:@"weekly" title:NSLocalizedString(@"SettingsWeekly", @"organize by week") type:FKFormAttributeMappingTypeBoolean];
        
        
        [formMapping sectionWithTitle:NSLocalizedString(@"SettingsMeasurementHeader", @"measurement header in settings")  identifier:@"Measurement"];
        
        [formMapping mapAttribute:@"weight" title:NSLocalizedString(@"SettingsWeight", @"weight in settings")  type:FKFormAttributeMappingTypeInteger];
        [formMapping mapAttribute:@"countdown" title:NSLocalizedString(@"SettingsCountdown", @"countdown  in settings")type:FKFormAttributeMappingTypeInteger];
        
        [formMapping mapAttribute:@"autopause" title:NSLocalizedString(@"SettingsAutoPause", @"auto pause switch in settings") type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"metric" title:NSLocalizedString(@"SettingsUnits", @"units switch in settings") type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"showSpeed" title:NSLocalizedString(@"SettingsShowSpeed", @"show speed switch in settings") type:FKFormAttributeMappingTypeBoolean];
        
        
        [formMapping sectionWithTitle:NSLocalizedString(@"SettingsAudioHeader", @"audio cues header in settings")  identifier:@"sdf"];
        [formMapping mapAttribute:@"speech" title:NSLocalizedString(@"SettingsSpeech", @"enable speech  in settings")type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"speechTime" title:NSLocalizedString(@"SettingsSpeechTime", @"enable speech time  in settings")type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"speechDistance" title:NSLocalizedString(@"SettingsSpeechDistance", @"enable speech distance  in settings")type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"speechCalories" title:NSLocalizedString(@"SettingsSpeechCalories", @"enable speech calories  in settings")type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"speechPace" title:NSLocalizedString(@"SettingsSpeechPace", @"enable speech pace  in settings")type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"speechCurPace" title:NSLocalizedString(@"SettingsSpeechCurPace", @"enable speech current pace  in settings")type:FKFormAttributeMappingTypeBoolean];


        //restore button
        if(restoreAvailable)
        {
            [formMapping sectionWithTitle:@"" identifier:@"restoreButSection"];
            
            [formMapping button:NSLocalizedString(@"SettingsRestorePurchase", @"restore purchase word")
                     identifier:@"restoreButton" handler:^(id object){
                         
                         //restore product
                         [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue* transaction){
                             
                             //success
                             //hide button
                             restoreAvailable = false;
                             prefsToChange.purchased = [NSNumber numberWithBool:true];
                             
                             //show notification
                             StandardNotifyVC * vc = [[StandardNotifyVC alloc] initWithNibName:@"StandardNotify" bundle:nil];
                             [vc.view setBackgroundColor:[Util redColour]];
                             [vc.view.layer setCornerRadius:5.0f];
                             [vc.titleLabel setText:NSLocalizedString(@"thankyou","")];
                             [vc.updateLabel setText:NSLocalizedString(@"SettingsRestoreSuccess","restore succes")];
                             
                             [self presentPopupViewController:vc animationType:MJPopupViewAnimationSlideTopBottom];
                             
                         } OnFail:^(SKPaymentQueue* payment,NSError* error){
                             
                             //show error
                             //show notification
                             StandardNotifyVC * vc = [[StandardNotifyVC alloc] initWithNibName:@"StandardNotify" bundle:nil];
                             [vc.view setBackgroundColor:[Util redColour]];
                             [vc.view.layer setCornerRadius:5.0f];
                             [vc.titleLabel setText:NSLocalizedString(@"SettingsRestoreFailTitle","restore fail title")];
                             [vc.updateLabel setText:NSLocalizedString(@"SettingsRestoreFail","restore fail title")];
                             /*
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SettingsRestoreFailTitle", @"restore fail title")
                                                                        message:NSLocalizedString(@"SettingsRestoreFail", @"restore fail ")
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                             [alert show];
                              */
                         }];
                     }
                   accesoryType:UITableViewCellAccessoryNone];
        }
        
        /*
        [formMapping sectionWithTitle:NSLocalizedString(@"SettingsSharingHeader", @"sharing header in settings")  identifier:@"sdf"];
        
        [formMapping mapAttribute:@"facebook" title:NSLocalizedString(@"SettingsFacebook", @"fb posting in settings") type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"twitter" title:NSLocalizedString(@"SettingsTwitter", @"twitter posting  in settings")  type:FKFormAttributeMappingTypeBoolean];
        */
        
        [self.formModel registerMapping:formMapping];
    }];
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {
        NSLog(@"did change model value");
    }];
    
    [self.formModel loadFieldsWithObject:prefsToChange ];
    
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


@end
