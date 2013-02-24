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
        
        [formMapping buttonSave:@"Create Goal" handler:^{
            NSLog(@"save pressed");
            NSLog(@"%@", goal);
            [self.formModel save];
            DataTest * user = [DataTest sharedData];
            user.curGoal = goal;
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        
        
        
        [formMapping sectionWithTitle:sectionForGoal  identifier:@"info"];
        
        if(goal.type == GoalTypeTotalDistance)
            [formMapping mapAttribute:@"value" title:valueText type:FKFormAttributeMappingTypeInteger];
        else if(goal.type == GoalTypeCalories)
            [formMapping mapAttribute:@"race"//to be converted afterwards
                                title:valueText
                         showInPicker:YES
                    selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                        *selectedValueIndex = 0;//1 lb
                        return [NSArray arrayWithObjects:@"1 lb", @"2 lb",@"3 lb",@"4 lb",@"5 lb",@"6 lb", @"7 lb",@"8 lb",@"9 lb",@"10 lb", @"11 lb", @"12 lb",@"13 lb",@"14 lb",@"15 lb",@"16 lb", @"17 lb",@"18 lb",@"19 lb",@"20 lb",@"21 lb", @"22 lb",@"23 lb",@"24 lb",@"25 lb",@"26 lb", @"27 lb",@"28 lb",@"29 lb",@"30 lb", nil];
                        
                    } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                        return value;
                        
                    } labelValueBlock:^id(id value, id object) {
                        return value;
                        
                    }];
        else//need the race selector for races
            [formMapping mapAttribute:@"race"
                            title:@"Race Type"
                     showInPicker:YES
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
        
        
        [formMapping sectionWithTitle:@"" identifier:@"cancelButSection"];
        
        [formMapping button:@"Cancel" identifier:@"cancelButton" handler:^(id object){
            [self dismissViewControllerAnimated:true completion:nil];
            //dont save
            
        }
               accesoryType:UITableViewCellAccessoryNone];
        
        [self.formModel registerMapping:formMapping];
    }];
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {
        NSLog(@"did change model value");
        NSLog([value description]);
    }];
    
    [self.formModel loadFieldsWithObject:goal];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
