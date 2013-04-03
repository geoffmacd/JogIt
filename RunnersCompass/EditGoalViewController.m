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

@synthesize  formModel,tempGoal;

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

    
    NSString * sectionForGoal = [tempGoal stringForHeaderDescription];
    NSString * valueText = [tempGoal stringForEdit1];
    NSString * valueText2 = [tempGoal stringForEdit2];
    
    
    [FKFormMapping mappingForClass:[Goal class] block:^(FKFormMapping *formMapping) {
        
        [formMapping sectionWithTitle:@"" identifier:@"saveButton"];
        
        [formMapping buttonSave:NSLocalizedString(@"CreateGoalButton", @"Create goal in edit screen") handler:^{
            
            //confirm goal is valid before saving, this will handle error validation as well
            if([tempGoal validateGoalEntry])
            {
                //send notification to app delegate
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"goalChangedNotification"
                 object:tempGoal];
            
                [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:true completion:nil];
            }
        }];
        
        
        
        [formMapping sectionWithTitle:sectionForGoal  identifier:@"info"];
        
        //all of the following use the value parameter
        if(tempGoal.type == GoalTypeTotalDistance)
        {
            [formMapping mapAttribute:@"value" title:valueText type:FKFormAttributeMappingTypeInteger];
            
            //validationn
            [formMapping validationForAttribute:@"value" validBlock:^BOOL(NSString *value, id object) {
                return tempGoal.value;
                
            } errorMessageBlock:^NSString *(id value, id object) {
                return NSLocalizedString(@"GoalValidationDistanceError", @"validation for no distance entered"); 
            }];
        }
        else if(tempGoal.type == GoalTypeCalories)
        {
            [formMapping mapAttribute:@"weight"//to be converted afterwards
                                title:valueText
                         showInPicker:YES
                    selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                        *selectedValueIndex = 0;//1 lb
                        return [tempGoal getWeightNames];
                        
                    } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                        tempGoal.value = [[tempGoal fatDictionary] objectForKey:value];
                        return value;
                        
                    } labelValueBlock:^id(id value, id object) {
                        return value;
                        
                    }];
            
            //validationn
            [formMapping validationForAttribute:@"weight" validBlock:^BOOL(NSString *value, id object) {
                return tempGoal.weight;
                
            } errorMessageBlock:^NSString *(id value, id object) {
                return NSLocalizedString(@"GoalValidationWeightError", @"validation for no weight loss entered");
            }];
        }
        else if(tempGoal.type == GoalTypeOneDistance || tempGoal.type == GoalTypeRace)//need the race selector for races
        {
            [formMapping mapAttribute:@"race"
                            title:valueText
                     showInPicker:YES
                selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){

                    *selectedValueIndex = 0;//1 mile
                    return [tempGoal getRaceNames];
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                    tempGoal.value = [[tempGoal raceDictionary] objectForKey:value];
                    return value;
                    
                } labelValueBlock:^id(id value, id object) {
                    return value;
                    
                }];
            
            //validationn
            [formMapping validationForAttribute:@"race" validBlock:^BOOL(NSString *value, id object) {
                return tempGoal.race;
                
            } errorMessageBlock:^NSString *(id value, id object) {
                return NSLocalizedString(@"GoalValidationTimeError", @"validation for no time entered"); //@"Must enter a time.";
            }];
        }
        
        //only if it exists do we use the time parameter
        if(valueText2)
        {
            [formMapping mapAttribute:@"time" title:valueText2 type:FKFormAttributeMappingTypeTime];
            
            //validationn
            [formMapping validationForAttribute:@"time" validBlock:^BOOL(NSString *value, id object) {
                return tempGoal.time;
                
            } errorMessageBlock:^NSString *(id value, id object) {
                return  NSLocalizedString(@"GoalValidationTimeError", @"validation for no time entered");//@"Must enter a time.";
            }];
        }
        
        [formMapping mappingForAttribute:@"startDate"
                                   title: NSLocalizedString(@"GoalStartLabel", @"label for goal edit form")//@"Start Date"
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];
        //validationn
        [formMapping validationForAttribute:@"startDate" validBlock:^BOOL(NSString *value, id object) {
            return [tempGoal.endDate compare:tempGoal.startDate ] == NSOrderedDescending;
            
        } errorMessageBlock:^NSString *(id value, id object) {
            return NSLocalizedString(@"GoalValidationDateError", @"validation for dates being incorrect order");//@"Target date must be after start!";
        }];
        
        [formMapping mappingForAttribute:@"endDate"
                                   title: NSLocalizedString(@"GoalEndLabel", @"label for goal edit form")
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];
        //validationn
        [formMapping validationForAttribute:@"endDate" validBlock:^BOOL(NSString *value, id object) {
            return [tempGoal.endDate compare:tempGoal.startDate ] == NSOrderedDescending;
            
        } errorMessageBlock:^NSString *(id value, id object) {
            return NSLocalizedString(@"GoalValidationDateError", @"validation for dates being incorrect order");//@"Target date must be after start!";
        }];
        
        
        [formMapping sectionWithTitle:@"" identifier:@"cancelButSection"];
        
        [formMapping button:NSLocalizedString(@"CancelWord", @"cancel word")
                 identifier:@"cancelButton" handler:^(id object){
            [self dismissViewControllerAnimated:true completion:nil];
            //dont save
            
        }
               accesoryType:UITableViewCellAccessoryNone];


        
        //completion
        [self.formModel registerMapping:formMapping];
    }];
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {
       // NSLog(@"did change model value");
      //  NSLog([value description]);
    }];
    
    [self.formModel loadFieldsWithObject:tempGoal];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
