//
//  Settings.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "SettingsViewController.h"
#import "EditTableCell.h"
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
    
    UserPrefs *movie = [UserPrefs movieWithTitle:@"Full name"
                                 content:@"After rescuing Han Solo from the palace of Jabba the Hutt, the Rebels attempt to destroy the Second Death Star, while Luke Skywalker tries to bring his father back to the Light Side of the Force."];
    
    movie.shortName = @"SWEVI";
    movie.suitAllAges = [NSNumber numberWithBool:YES];
    movie.numberOfActor = [NSNumber numberWithInt:4];
    movie.releaseDate = [NSDate date];
    movie.rate = [NSNumber numberWithFloat:5];
    
    self.prefs = movie;
    
    [FKFormMapping mappingForClass:[UserPrefs class] block:^(FKFormMapping *formMapping) {
        [formMapping sectionWithTitle:@"" identifier:@"saveButton"];
        
        [formMapping buttonSave:@"Done" handler:^{
            NSLog(@"save pressed");
            NSLog(@"%@", self.prefs);
            [self.formModel save];
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        
        
        [formMapping sectionWithTitle:@"Personal"  identifier:@"info"];
        
        [formMapping mapAttribute:@"title" title:@"Full name" type:FKFormAttributeMappingTypeText];
        [formMapping mappingForAttribute:@"releaseDate"
                                   title:@"Birthdate"
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];
        [formMapping mapAttribute:@"numberOfActor" title:@"Weight" type:FKFormAttributeMappingTypeInteger];
        [formMapping mapAttribute:@"suitAllAges" title:@"Gender" type:FKFormAttributeMappingTypeBoolean];
        
        
        [formMapping sectionWithTitle:@"Measurement" identifier:@"bob"];
        
        [formMapping mapAttribute:@"suitAllAges" title:@"Auto-Pause" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"suitAllAges" title:@"Metric Units" type:FKFormAttributeMappingTypeBoolean];

        
        [formMapping sectionWithTitle:@"Sharing" identifier:@"sdf"];
        
        [formMapping mapAttribute:@"suitAllAges" title:@"Facebook" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"suitAllAges" title:@"Twitter" type:FKFormAttributeMappingTypeBoolean];
        
        
        
        
        [self.formModel registerMapping:formMapping];
    }];
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {
        NSLog(@"did change model value");
    }];
    
    [self.formModel loadFieldsWithObject:movie];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
