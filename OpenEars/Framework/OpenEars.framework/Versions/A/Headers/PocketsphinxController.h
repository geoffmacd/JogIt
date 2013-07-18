//  OpenEars 
//  http://www.politepix.com/openears
//
//  PocketsphinxController.h
//  OpenEars
//
//  PocketsphinxController is a class which controls the creation and management of
//  a continuous speech recognition loop.
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  this file is licensed under the Politepix Shared Source license found 
//  found in the root of the source distribution. Please see the file "Version.txt" in the root of 
//  the source distribution for the version number of this OpenEars package.


#import <Foundation/Foundation.h>
#import "OpenEarsEventsObserver.h"
/**\cond HIDDEN_SYMBOLS*/   
#import "ContinuousModel.h"
#import "AudioConstants.h"
/**\endcond */   

/**
 @class  PocketsphinxController
 @brief  The class that controls local speech recognition in OpenEars.
 
 ## Usage examples
 > Preparing to use the class:
 @htmlinclude PocketsphinxController_Preconditions.txt
 > What to add to your header:
 @htmlinclude PocketsphinxController_Header.txt
 > What to add to your implementation:
 @htmlinclude PocketsphinxController_Implementation.txt
 > How to use the class methods:
 @htmlinclude PocketsphinxController_Calls.txt 
 @warning There can only be one PocketsphinxController instance in your app.
 */

@interface PocketsphinxController : NSObject <OpenEarsEventsObserverDelegate> {
/**\cond HIDDEN_SYMBOLS*/ 
	NSThread *voiceRecognitionThread; // The loop would lock if run on the main thread so it has a background thread in which it always runs.
	ContinuousModel *continuousModel; // The continuous model is the actual recognition loop.
	OpenEarsEventsObserver *openEarsEventsObserver; // We use an OpenEarsEventsObserver here to get important information from other objects which may be instantiated.
    /**\endcond */ 
    /**This is how long PocketsphinxController should wait after speech ends to attempt to recognize speech. This defaults to .7 seconds.*/
    float secondsOfSilenceToDetect;
    /**Advanced: set this to TRUE to receive n-best results.*/    
    BOOL returnNbest;
    /**Advanced: the number of n-best results to return. This is a maximum number to return -- if there are null hypotheses fewer than this number will be returned.*/
    int nBestNumber;
    /**How long to calibrate for. This can only be one of the values '1', '2', or '3'. Defaults to 1.*/
    int calibrationTime;
    /**Turn on verbose output. Do this any time you encounter an issue and any time you need to report an issue on the forums.*/
    BOOL verbosePocketSphinx;
    /**By default, PocketsphinxController won't return a hypothesis if for some reason the hypothesis is null (this can happen if the perceived sound was just noise). If you need even empty hypotheses to be returned, you can set this to TRUE before starting PocketsphinxController.*/
    BOOL returnNullHypotheses;
/**\cond HIDDEN_SYMBOLS*/ 
    BOOL processSpeechLocally;
    BOOL outputAudio;
    int sampleRate;
/**\endcond*/     
}

// These are the OpenEars methods for controlling Pocketsphinx. You should use these.

/**Start the speech recognition engine up. You provide the full paths to a language model and a dictionary file which are created using LanguageModelGenerator.*/
- (void) startListeningWithLanguageModelAtPath:(NSString *)languageModelPath dictionaryAtPath:(NSString *)dictionaryPath languageModelIsJSGF:(BOOL)languageModelIsJSGF;  // Starts the recognition loop.
/**Shut down the engine. You must do this before releasing a parent view controller that contains PocketsphinxController.*/
- (void) stopListening; // Exits from the recognition loop.
/**Keep the engine going but stop listening to speech until resumeRecognition is called. Takes effect instantly.*/
- (void) suspendRecognition; // Stops interpreting sounds as speech without exiting from the recognition loop. You do not need to call these methods on behalf of Flite.
/**Resume listening for speech after suspendRecognition has been called.*/
- (void) resumeRecognition; // Starts interpreting sounds as speech after suspending recognition with the preceding method. You do not need to call these methods on behalf of Flite.
/**Change from one language model to another. This lets you change which words you are listening for depending on the context in your app.*/
- (void) changeLanguageModelToFile:(NSString *)languageModelPathAsString withDictionary:(NSString *)dictionaryPathAsString; // If you have already started the recognition loop and you want to switch to a different language model, you can use this and the model will be changed at the earliest opportunity. Will not have any effect unless recognition is already in progress.
/**Gives the volume of the incoming speech. This is a UI hook. You can't read it on the main thread or it will block.*/
- (Float32) pocketsphinxInputLevel; // This gives the input metering levels. This can only be run in a background thread that you create, otherwise it will block recognition


/**\cond HIDDEN_SYMBOLS*/ 
// Here are all the multithreading methods, you should never do anything with any of these.
- (void) startVoiceRecognitionThreadWithLanguageModelAtPath:(NSString *)languageModelPath dictionaryAtPath:(NSString *)dictionaryPath languageModelIsJSGF:(BOOL)languageModelIsJSGF;
- (void) stopVoiceRecognitionThread;
- (void) waitForVoiceRecognitionThreadToFinish;
- (void) startVoiceRecognitionThreadAutoreleasePoolWithArray:(NSArray *)arrayOfLanguageModelItems; // This is the autorelease pool in which the actual business of our loop is handled.

// Suspend and resume that is initiated by Flite. Do not call these directly.
- (void) suspendRecognitionForFliteSpeech;
- (void) resumeRecognitionForFliteSpeech;

// Do not call this directly, set it by assigning a float value to secondsOfSilenceToDetect
- (void) setSecondsOfSilence;
/**\endcond */ 

// Run one synchronous recognition pass on a recording from its beginning to its end and stop.
/**You can use this to run recognition on an already-recorded WAV file for testing. The WAV file has to be 16-bit and 16000 samples per second.*/
- (void) runRecognitionOnWavFileAtPath:(NSString *)wavPath usingLanguageModelAtPath:(NSString *)languageModelPath dictionaryAtPath:(NSString *)dictionaryPath languageModelIsJSGF:(BOOL)languageModelIsJSGF;

/**\cond HIDDEN_SYMBOLS*/ 
@property (nonatomic, retain) NSThread *voiceRecognitionThread; // The loop would lock if run on the main thread so it has a background thread in which it always runs.
@property (nonatomic, retain) ContinuousModel *continuousModel; // The continuous model is the actual recognition loop.
@property (nonatomic, retain) OpenEarsEventsObserver *openEarsEventsObserver; // We use an OpenEarsEventsObserver here to get important information from other objects which may be instantiated.
/**\endcond */ 
@property (nonatomic, assign) float secondsOfSilenceToDetect;
@property (nonatomic, assign) BOOL returnNbest;
@property (nonatomic, assign) int nBestNumber;
@property (nonatomic, assign) int calibrationTime; // This can only be one of the values '1', '2', or '3'. Defaults to 1.
@property (nonatomic, assign) BOOL verbosePocketSphinx;
@property (nonatomic, assign) BOOL processSpeechLocally;
@property (nonatomic, assign) BOOL returnNullHypotheses;
@property (nonatomic, assign) BOOL outputAudio;
@property (nonatomic, assign) int sampleRate;

@end
