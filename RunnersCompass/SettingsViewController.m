//
//  Settings.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "SettingsViewController.h"
#import "FormKit.h"

@interface SettingsViewController()

@end

@implementation SettingsViewController

@synthesize formModel,prefsToChange,oldMetric,oldShowSpeed;

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
        [formMapping sectionWithTitle:NSLocalizedString(@"SettingsMeasurementHeader", @"measurement header in settings")  identifier:@"Measurement"];
        
        [formMapping mapAttribute:@"weight" title:NSLocalizedString(@"SettingsWeight", @"weight in settings")  type:FKFormAttributeMappingTypeInteger];
        
        [formMapping mapAttribute:@"autopause" title:NSLocalizedString(@"SettingsAutoPause", @"auto pause switch in settings") type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"metric" title:NSLocalizedString(@"SettingsUnits", @"units switch in settings") type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"showSpeed" title:NSLocalizedString(@"SettingsShowSpeed", @"show speed switch in settings") type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"countdown" title:NSLocalizedString(@"SettingsCountdown", @"countdown  in settings")type:FKFormAttributeMappingTypeInteger];

        
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
