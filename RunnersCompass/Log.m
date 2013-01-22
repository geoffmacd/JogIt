//
//  Log.m
//  Momentum
//
//  Created by Louis Ortego on 12-04-16.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Log.h"

@implementation Log

+ (void)logMessageOfType:(NSUInteger)messageType 
              withmat:(NSString *)logMessage, ...
{
    //If the program is NOT in debug mode, debug messages will not be processed.
#ifndef DEBUG
    if(messageType == LogDebug)
    {
        return;
    }
#endif
    
    if(logMessage == nil)
    {
        [Log logMessageOfType:LogWarning withmat:@"nil Message Sent to Error Logger!"];
        return; 
    }
    
    va_list args;
    
    NSString *messageTypeString;
    
    switch (messageType)
    {
        case LogDebug:
            messageTypeString = @"DEBUG";
            break;
            
        case LogInfo:
            messageTypeString = @"INFO";
            break;
            
        case LogWarning:
            messageTypeString = @"WARNING";
            break;
            
        case LogError:
            messageTypeString = @"ERROR";
            break;
            
        default:
            [Log logMessageOfType:LogWarning withmat:@"Unknown Message Type sent to Log"];
            messageTypeString = @"UNKNOWN MESSAGE TYPE";
            break;
    }
    
    va_start(args, logMessage);
    
    NSString *logString = [[NSString alloc]initWithFormat:logMessage arguments:args];
    
    NSLog(@"- %@ -: %@", messageTypeString, logString);
    
    va_end(args);
}

@end
