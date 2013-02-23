//
//  EditGoalViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "EditGoalViewController.h"
#import "FormKit.h"

@interface EditGoalViewController ()

@end

@implementation EditGoalViewController

@synthesize prefs, formModel;

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
    
    UserPrefs *movie = [UserPrefs defaultUser];
    
    self.prefs = movie;
    
    [FKFormMapping mappingForClass:[UserPrefs class] block:^(FKFormMapping *formMapping) {
        
        [formMapping sectionWithTitle:@"" identifier:@"saveButton"];
        
        [formMapping buttonSave:@"Create Goal!" handler:^{
            NSLog(@"save pressed");
            NSLog(@"%@", self.prefs);
            [self.formModel save];
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        
        
        
        [formMapping sectionWithTitle:@""  identifier:@"info"];
        
        [formMapping mapAttribute:@"numberOfActor" title:@"Distance" type:FKFormAttributeMappingTypeInteger];
        
        [formMapping mappingForAttribute:@"releaseDate"
                                   title:@"Start Date"
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];
        [formMapping mappingForAttribute:@"releaseDate"
                                   title:@"End Date"
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];
        
        
        
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
