
#import "PacePicker.h"

@interface PacePicker()
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,assign) NSInteger selectedIndexMin;
@property (nonatomic,assign) NSInteger selectedIndexSecond;
@end

@implementation PacePicker
@synthesize data = _data;
@synthesize selectedIndexMin;
@synthesize selectedIndexSecond;
@synthesize onRunFormDone = _onRunFormDone;
@synthesize onRunFormCancel = _onRunFormCancel;

+ (id)showPickerWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSInteger)index doneBlock:(PaceActionStringDoneBlock)doneBlock cancelBlock:(PaceActionStringCancelBlock)cancelBlockOrNil origin:(id)origin {
    PacePicker * picker = [[PacePicker alloc] initWithTitle:title rows:strings initialSelection:index doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    [picker showRunFormPicker];
    return picker ;
}

- (id)initWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSInteger)index doneBlock:(PaceActionStringDoneBlock)doneBlock cancelBlock:(PaceActionStringCancelBlock)cancelBlockOrNil origin:(id)origin {
    self = [self initWithTitle:title rows:strings initialSelection:index target:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onRunFormDone = doneBlock;
        self.onRunFormCancel = cancelBlockOrNil;
    }
    return self;
}

+ (id)showPickerWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    PacePicker *picker = [[PacePicker alloc] initWithTitle:title rows:data initialSelection:index target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    [picker showRunFormPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.data = data;
        self.selectedIndexSecond = index;
        self.selectedIndexMin = 0;
        self.title = title;
    }
    return self;
}



- (UIView *)configuredPickerView {
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = YES;
    [stringPicker selectRow:self.selectedIndexSecond inComponent:0 animated:NO];
    [stringPicker selectRow:self.selectedIndexMin inComponent:0 animated:NO];
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    return stringPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {    
    if (self.onRunFormDone) {
        _onRunFormDone(self, (self.selectedIndexMin + (self.selectedIndexSecond*60)), [self.data objectAtIndex:self.selectedIndexSecond]);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
        [target performSelector:successAction withObject:[NSNumber numberWithInt:(self.selectedIndexMin + (self.selectedIndexSecond*60))] withObject:origin];
        return;
    }
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onRunFormCancel) {
        _onRunFormCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction])
        [target performSelector:cancelAction withObject:origin];
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0)
        self.selectedIndexSecond = row;
    else
        self.selectedIndexMin = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //return self.data.count;
    if(component == 0)
        return 12;
    if(component == 1)
        return 60;
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //return [self.data objectAtIndex:row];
    if(component == 0)
        return [NSString stringWithFormat:@"%d m" , row];
    
    return [NSString stringWithFormat:@"%d s" , row];
    
      
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width/3;
}


@end