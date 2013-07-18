//  OpenEars 
//  http://www.politepix.com/openears
//
//  AudioSessionManager.h
//  OpenEars
//
//  AudioSessionManager is a singleton class for initializing the Audio Session and forwarding changes in the Audio
//  Session to the OpenEarsEventsObserver class so they can be reacted to when necessary.
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  this file is licensed under the Politepix Shared Source license found 
//  found in the root of the source distribution. Please see the file "Version.txt" in the root of 
//  the source distribution for the version number of this OpenEars package.


//  This class creates an Audio Session and forwards important notification about
//  Audio Session status changes to OpenEarsEventsObserver.
/**\cond HIDDEN_SYMBOLS*/
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h> 
#import "AudioConstants.h"


@interface AudioSessionManager : NSObject {
    BOOL soundMixing;
}

@property(nonatomic, assign) BOOL soundMixing; // This lets background sounds like iPod music and alerts play during your app session (also likely to cause those elements to be recognized by an active Pocketsphinx decoder, so only set this to true after initializing your audio session if you know you want this for some reason.)

-(void) startAudioSession; // All that we need to access from outside of this class is the method to start the Audio Session.

+ (id)sharedAudioSessionManager;
/**\endcond*/
@end
