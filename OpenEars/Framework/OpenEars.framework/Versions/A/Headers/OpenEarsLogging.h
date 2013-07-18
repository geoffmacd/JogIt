//
//  OpenEarsLogging.h
//  OpenEars
//
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  this file is licensed under the Politepix Shared Source license found 
//  found in the root of the source distribution. Please see the file "Version.txt" in the root of 
//  the source distribution for the version number of this OpenEars package.

/**
 @class  OpenEarsLogging
 @brief  A singleton which turns logging on or off for the entire framework. The type of logging is related to overall framework functionality such as the audio session and timing operations. Please turn OpenEarsLogging on for any issue you encounter. It will probably show the problem, but if not you can show the log on the forum and get help.
 @warning The individual classes such as PocketsphinxController and LanguageModelGenerator have their own verbose flags which are separate from OpenEarsLogging. 
 */

@interface OpenEarsLogging : NSObject



/**
@brief   This just turns on logging. If you don't want logging in your session, don't send the startOpenEarsLogging message.

> Example Usage:
Before implementation:
@code
#import <OpenEars/OpenEarsLogging.h>;
@endcode
In implementation:
@code 
[OpenEarsLogging startOpenEarsLogging];
@endcode
*/

+ (id)startOpenEarsLogging;

@end
