//
//  SWILog.h
//  Momentum
//
//  Created by Louis Ortego on 12-04-16.
//  Copyright (c) 2012 SWI. All rights reserved.
//

@interface Log : NSObject

typedef enum
{
    LogDebug,
    LogInfo,
    LogWarning,
    LogError
} LogType;

+ (void)logMessageOfType:(NSUInteger)messageType 
              withFormat:(NSString *)message, ...;

@end
