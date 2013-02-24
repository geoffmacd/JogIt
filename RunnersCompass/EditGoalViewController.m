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

@synthesize goal, formModel;

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
    
    NSString * sectionForGoal;
    NSString * valueText;
    NSString * valueText2;
    
    switch (goal.type) {
        case GoalTypeTotalDistance:
            sectionForGoal = @"Total Distance Over Time";
            valueText = @"Cumulative Distance";
            break;
        case GoalTypeRace:
            sectionForGoal = @"Fastest Race Time";
            valueText2 = @"Time to Beat";
            valueText = @"Race";
            break;
        case GoalTypeOneDistance:
            sectionForGoal = @"Finish a Race";
            valueText = @"Race";
            break;
        case GoalTypeCalories:
            sectionForGoal = @"Burn Fat";
            valueText = @"Weight Loss(3500cal/lb)";
            break;
            
        default:
            break;
    }
    
    [FKFormMapping mappingForClass:[Goal class] block:^(FKFormMapping *formMapping) {
        
        [formMapping sectionWithTitle:@"" identifier:@"saveButton"];
        
        [formMapping buttonSave:@"Save" handler:^{
            NSLog(@"save pressed");
            NSLog(@"%@", goal);
            [self.formModel save];
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        
        
        
        [formMapping sectionWithTitle:sectionForGoal  identifier:@"info"];
        
        if(goal.type != GoalTypeOneDistance && goal.type != GoalTypeRace)
            [formMapping mapAttribute:@"value" title:valueText type:FKFormAttributeMappingTypeInteger];
        else//need the race selector for races
            [formMapping mapAttribute:@"race"
                            title:@"Race Type"
                     showInPicker:NO
                selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                    *selectedValueIndex = 0;//1 mile
                    return [goal getRaceTypes];
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                    return value;
                    
                } labelValueBlock:^id(id value, id object) {
                    return value;
                    
                }];
                    
                    
                    
        
        //only if it exists do we use this
        if(valueText2)
            [formMapping mapAttribute:@"value2" title:valueText2 type:FKFormAttributeMappingTypeTime];
        
        [formMapping mappingForAttribute:@"startDate"
                                   title:@"Start Date"
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];
        [formMapping mappingForAttribute:@"endDate"
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
    
    [self.formModel loadFieldsWithObject:goal];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
