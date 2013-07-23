//  OpenEars 
//  http://www.politepix.com/openears
//
//  FliteController.h
//  OpenEars
//
//  FliteController is a class which manages text-to-speech
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  this file is licensed under the Politepix Shared Source license found 
//  found in the root of the source distribution. Please see the file "Version.txt" in the root of 
//  the source distribution for the version number of this OpenEars package.


#import <AVFoundation/AVFoundation.h>

#import "OpenEarsEventsObserver.h"
#import "AudioConstants.h"
/**\cond HIDDEN_SYMBOLS*/   
#import "flite.h"
/**\endcond */   
#import "FliteVoice.h"
#import <dispatch/dispatch.h>
/**
@class  FliteController
@brief  The class that controls speech synthesis (TTS) in OpenEars.

## Usage examples
> Preparing to use the class:
@htmlinclude FliteController_Preconditions.txt
> What to add to your header:
@htmlinclude FliteController_Header.txt
> What to add to your implementation:
@htmlinclude FliteController_Implementation.txt
> How to use the class methods:
@htmlinclude FliteController_Calls.txt 
@warning There can only be one FliteController instance in your app at any given moment.
*/
 
@interface FliteController : NSObject <AVAudioPlayerDelegate, OpenEarsEventsObserverDelegate> {
/**duration_stretch changes the speed of the voice. It is on a scale of 0.0-2.0 where 1.0 is the default.*/	
    float duration_stretch;
/**target_mean changes the pitch of the voice. It is on a scale of 0.0-2.0 where 1.0 is the default.*/
	float target_mean;
/**target_stddev changes convolution of the voice. It is on a scale of 0.0-2.0 where 1.0 is the default.*/    
	float target_stddev;
/**Set userCanInterruptSpeech to TRUE in order to let new incoming human speech cut off synthesized speech in progress.*/    
    BOOL userCanInterruptSpeech;
    
/**\cond HIDDEN_SYMBOLS*/    
	AVAudioPlayer *audioPlayer; // Plays back the speech
	OpenEarsEventsObserver *openEarsEventsObserver; // Observe status changes from audio sessions and Pocketsphinx
	NSData *speechData;
	BOOL speechInProgress;
    BOOL quietFlite;
    dispatch_queue_t backgroundQueue;
/**\endcond */    
}

/**This takes an NSString which is the word or phrase you want to say, and the FliteVoice to use to say the phrase.
Usage Example:
 @code
 [self.fliteController say:@"Say it, don't spray it." withVoice:self.slt];
 @endcode
 There are a total of nine FliteVoices available for use with OpenEars. The Slt voice is the most popular one and it ships with OpenEars. The other eight voices can be downloaded as part of the OpenEarsExtras package available at the URL <a href="http://bitbucket.org/Politepix/openearsextras">http://bitbucket.org/Politepix/openearsextras</a>. To use them, just drag the desired downloaded voice's framework into your app, import its header at the top of your calling class (e.g. import &lt;Slt/Slt.h&gt; or import &lt;Rms/Rms.h&gt;) and instantiate it as you would any other object, then passing the instantiated voice to this method.
*/
- (void) say:(NSString *)statement withVoice:(FliteVoice *)voiceToUse;
/**A read-only attribute that tells you the volume level of synthesized speech in progress. This is a UI hook. You can't read it on the main thread. */
- (Float32) fliteOutputLevel;
// End methods to be called directly by an OpenEars project

/**\cond HIDDEN_SYMBOLS*/
// Interruption handling
- (void) interruptionRoutine:(AVAudioPlayer *)player;
- (void) interruptionOverRoutine:(AVAudioPlayer *)player;

// Handling not doing voice recognition on Flite speech, do not directly call
- (void) sendResumeNotificationOnMainThread;
- (void) sendSuspendNotificationOnMainThread;
- (void) interruptTalking;
/**\endcond*/

@property (nonatomic, assign) float duration_stretch;
@property (nonatomic, assign) float target_mean;
@property (nonatomic, assign) float target_stddev;
@property (nonatomic, assign) BOOL userCanInterruptSpeech;

/**\cond HIDDEN_SYMBOLS*/
@property (nonatomic, assign) BOOL speechInProgress;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;  // Plays back the speech
@property (nonatomic, retain) OpenEarsEventsObserver *openEarsEventsObserver; // Observe status changes from audio sessions and Pocketsphinx
@property (nonatomic, retain) NSData *speechData;
@property (nonatomic, assign) BOOL quietFlite;
/**\endcond */
@end





