//
// Created by Bruno Wernimont on 2012
// Copyright 2012 FormKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "FKTextField.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FKTextField

@synthesize textField = _textField;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] init];
        
        self.textField.textAlignment = UITextAlignmentRight;
        self.textField.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0f];
        self.textField.textColor = [UIColor whiteColor];
        
        [self.textField addTarget:self
                           action:@selector(textFieldDidChangeValue)
                 forControlEvents:UIControlEventAllEditingEvents];
   
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:13.0f];
        
        self.valueView = self.textField;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.textField.placeholder = nil;
    self.textField.text = nil;
    self.textField.delegate = nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textFieldDidChangeValue {
    
}


@end
