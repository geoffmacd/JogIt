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

@synthesize formModel,prefs;

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
    
    UserPrefs * newPrefs = [UserPrefs defaultUser];
    
    
    self.prefs = newPrefs;
    
    [FKFormMapping mappingForClass:[UserPrefs class] block:^(FKFormMapping *formMapping) {
        [formMapping sectionWithTitle:@"" identifier:@"saveButton"];
        
        [formMapping buttonSave:@"DONE" handler:^{
            NSLog(@"save pressed");
            NSLog(@"%@", self.prefs);
            [self.formModel save];
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        
        
        [formMapping sectionWithTitle:@"Personal"  identifier:@"info"];
        
        [formMapping mapAttribute:@"fullname" title:@"Full name" type:FKFormAttributeMappingTypeText];
        [formMapping mappingForAttribute:@"birthdate"
                                   title:@"Birthdate"
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];
        [formMapping mapAttribute:@"weight" title:@"Weight (lbs)" type:FKFormAttributeMappingTypeInteger];
        
        
        [formMapping sectionWithTitle:@"Measurement" identifier:@"bob"];
        
        [formMapping mapAttribute:@"autopause" title:@"Auto-Pause" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"metric" title:@"Metric Units" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"countdown" title:@"Countdown (sec)" type:FKFormAttributeMappingTypeInteger];

        
        [formMapping sectionWithTitle:@"Sharing" identifier:@"sdf"];
        
        [formMapping mapAttribute:@"facebook" title:@"Post to Facebook" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"twitter" title:@"Post to Twitter" type:FKFormAttributeMappingTypeBoolean];
        
        
        [self.formModel registerMapping:formMapping];
    }];
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {
        NSLog(@"did change model value");
    }];
    
    [self.formModel loadFieldsWithObject:newPrefs];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
