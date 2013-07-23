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

@synthesize  formModel,tempGoal,prefs;

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
    
    //ensure value is km 
    if(tempGoal.type == GoalTypeTotalDistance)
    {
        tempGoal.value = [NSNumber numberWithInt:[tempGoal.value integerValue]/1000];
        
        if(![prefs.metric boolValue])
        {
            //convert to miles until validateGoal
            tempGoal.value = [NSNumber numberWithInt:[tempGoal.value integerValue]*convertKMToMile];
        }
    }
    
    
    [FKFormMapping mappingForClass:[Goal class] block:^(FKFormMapping *formMapping) {
        
        [formMapping sectionWithTitle:@"" identifier:@"saveButton"];
        
        [formMapping buttonSave:NSLocalizedString(@"CreateGoalButton", @"Create goal in edit screen") handler:^{
            
            //validates all forms first
            [self.formModel save];
            
            //confirm goal is valid before saving, this will handle error validation as well
            if([tempGoal validateGoalEntry:[[prefs metric] boolValue]])
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
            [formMapping mapAttribute:@"value" title:valueText type:FKFormAttributeMappingTypeFloat];
            
            //validation
            [formMapping validationForAttribute:@"value" validBlock:^BOOL(NSString *value, id object) {
                //requires enddate to at least be entered
                return [tempGoal.value integerValue] > 0;
                
            } errorMessageBlock:^NSString *(id value, id object) {
                return NSLocalizedString(@"GoalValidationDistanceError", @"validation for distance being 0 or less");
            }];
            
        }
        else if(tempGoal.type == GoalTypeCalories)
        {
            [formMapping mapAttribute:@"weight"//to be converted afterwards
                                title:valueText
                         showInPicker:YES
                    selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                        //5 lb
                        *selectedValueIndex = 4;
                        return [Goal getWeightNames];
                        
                    } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                        return value;
                        
                    } labelValueBlock:^id(id value, id object) {
                        return value;
                        
                    }];
            
            //validation
            [formMapping validationForAttribute:@"weight" validBlock:^BOOL(NSString *value, id object) {
                //requires enddate to at least be entered
                return tempGoal.weight;
                
            } errorMessageBlock:^NSString *(id value, id object) {
                return NSLocalizedString(@"GoalValidationWeightError", @"validation for no weight");
            }];
            
        }
        else if(tempGoal.type == GoalTypeOneDistance || tempGoal.type == GoalTypeRace)//need the race selector for races
        {
            [formMapping mapAttribute:@"race"
                            title:valueText
                     showInPicker:YES
                selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                    //1 mile
                    *selectedValueIndex = 0;
                    return [Goal getRaceNames];
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                    return value;
                    
                } labelValueBlock:^id(id value, id object) {
                    return value;
                    
                }];
            
            //validation
            [formMapping validationForAttribute:@"race" validBlock:^BOOL(NSString *value, id object) {
                //requires enddate to at least be entered
                return tempGoal.race;
                
            } errorMessageBlock:^NSString *(id value, id object) {
                return NSLocalizedString(@"GoalValidationRaceError", @"validation for no race");
            }];
        }
        
        //only if it exists do we use the time parameter
        if(valueText2)
        {
            [formMapping mapAttribute:@"time" title:valueText2 type:FKFormAttributeMappingTypeTime];
            
            //validation
            [formMapping validationForAttribute:@"time" validBlock:^BOOL(NSString *value, id object) {
                return tempGoal.time;
                
            } errorMessageBlock:^NSString *(id value, id object) {
                return  NSLocalizedString(@"GoalValidationTimeError", @"validation for no time entered");//@"Must enter a time.";
            }];
        }
        
        //dates
        
        [formMapping mappingForAttribute:@"startDate"
                                   title: NSLocalizedString(@"GoalStartLabel", @"label for goal edit form")//@"Start Date"
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];
        
        //validationn
        [formMapping validationForAttribute:@"startDate" validBlock:^BOOL(NSString *value, id object) {
            //requires enddate to at least be entered
            return [tempGoal.endDate compare:tempGoal.startDate ] == NSOrderedDescending || !tempGoal.endDate;
            
        } errorMessageBlock:^NSString *(id value, id object) {
            return NSLocalizedString(@"GoalValidationDateError", @"validation for dates being incorrect order");//@"Target date must be after start!";
        }];
        
        [formMapping mappingForAttribute:@"endDate"
                                   title: NSLocalizedString(@"GoalEndLabel", @"label for goal edit form")
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];
        //validation
        [formMapping validationForAttribute:@"endDate" validBlock:^BOOL(NSString *value, id object) {
            return [tempGoal.endDate compare:tempGoal.startDate ] == NSOrderedDescending || !tempGoal.endDate;
            
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
    
    [self.formModel loadFieldsWithObject:tempGoal];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
