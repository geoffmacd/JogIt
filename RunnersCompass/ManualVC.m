//
//  Settings.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "ManualVC.h"
#import "FormKit.h"

@implementation ManualVC

@synthesize formModel,prefs,manualRun, manualRunRec,delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView
                                        navigationController:self.navigationController];

    manualRun = [[ManualRun alloc] init];
    [manualRun setName:NSLocalizedString(@"ManualRunTitle", @"Default run title for manual run")];
    [manualRun setDate:[NSDate date]];//to today
    [manualRun setTime:setDateToMidnite([NSDate date])];//to midnight for hour,minute,sec to be 0
    [manualRun setCalories:0.0];
    [manualRun setDistance:0.0];
    
    
    
    //miles or km
    NSString * titleForDistance = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"ManualDistanceentry", @"distance in manual run"), [prefs getDistanceUnit]];
    
    [FKFormMapping mappingForClass:[RunRecord class] block:^(FKFormMapping *formMapping) {
        [formMapping sectionWithTitle:@"" identifier:@"saveButton"];
        
        [formMapping buttonSave:NSLocalizedString(@"CreateGoalButton", @"save button")  handler:^{
            //NSLog(@"save pressed");
            
            //prevent future runs form being added
            if(!([manualRun.date compare:shiftDateByXdays([NSDate date],0)] == NSOrderedAscending))
                return;
            
            manualRunRec = [RunRecord MR_createEntity];
            [manualRunRec setName:NSLocalizedString(@"ManualRunTitle", @"Default run title for manual run")];
            [manualRunRec setEventType:[NSNumber numberWithInt:EventTypeManual]];
            [manualRunRec setTargetMetric:[NSNumber numberWithInt:NoMetricType]];
            [manualRunRec setCalories:[NSNumber numberWithFloat:manualRun.calories]];
            [manualRunRec setDate:manualRun.date];
            //multiply distance by 1000x to get meters
            manualRunRec.distance = [NSNumber numberWithDouble:manualRun.distance * 1000];
            //convert from miles if necessary
            if(![[prefs metric] boolValue])
                manualRunRec.distance = [NSNumber numberWithDouble:[manualRunRec.distance doubleValue] / convertKMToMile];
            
            //get time components
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
            NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: manualRun.time];
            //set time by components
            manualRunRec.time = [NSNumber numberWithDouble:((components.hour * 3600) + (components.minute *60))];
            //calc pace
            if([manualRunRec.time doubleValue] > 0)
            {
                manualRunRec.avgPace = [NSNumber numberWithDouble:[manualRunRec.distance doubleValue]/[manualRunRec.time doubleValue]];
            }
            
            //save to db
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            //need to load actual event with record to pass it back to menu in same way as logger
            RunEvent * runToPassToMenu = [[RunEvent alloc]initWithRecord:manualRunRec];
            //pass run 
            [delegate manualRunToSave:runToPassToMenu];
            
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        
        
        [formMapping sectionWithTitle:NSLocalizedString(@"ManualRunHeader", @"header for manual run details")   identifier:@"info"];
        
        //run details
        [formMapping mappingForAttribute:@"date"
                                   title:NSLocalizedString(@"ManualDate", @"run date for manual run")
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"yyyy-MM-dd";
                        }];        //validation
        [formMapping validationForAttribute:@"date" validBlock:^BOOL(NSString *value, id object) {
            //need to add one day to eliminate date concern if the same day is chosen
            //
            return [manualRun.date compare:shiftDateByXdays([NSDate date],0)] == NSOrderedAscending;
            
        } errorMessageBlock:^NSString *(id value, id object) {
            return NSLocalizedString(@"ManualRunDateValidation", @"");
        }];
        
        [formMapping mapAttribute:@"distance" title:titleForDistance  type:FKFormAttributeMappingTypeFloat];
        [formMapping mapAttribute:@"time" title:NSLocalizedString(@"ManualTimeEntry", @"time in manual run")  type:FKFormAttributeMappingTypeTime];
        [formMapping mapAttribute:@"calories" title:NSLocalizedString(@"ManualCaloriesEntry", @"calories in manual run")  type:FKFormAttributeMappingTypeInteger];
        
        

        
        [formMapping sectionWithTitle:@"" identifier:@"cancelButSection"];
        
        [formMapping button:NSLocalizedString(@"CancelWord", @"cancel word")
                 identifier:@"cancelButton" handler:^(id object){
                     
                     //dont save
                     [delegate manualRunCancelled];
                     
                     //delete record everytime this closess
                     //[manualRunRec MR_deleteEntity];
                     
                     [self dismissViewControllerAnimated:true completion:nil];
                     
                 }
               accesoryType:UITableViewCellAccessoryNone];
        
        [self.formModel registerMapping:formMapping];
    }];
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {
        //NSLog(@"did change model value");
    }];
    
    [self.formModel loadFieldsWithObject:manualRun];
    
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
