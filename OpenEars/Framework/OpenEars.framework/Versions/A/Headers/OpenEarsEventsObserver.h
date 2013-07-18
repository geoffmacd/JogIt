//  OpenEars 
//  http://www.politepix.com/openears
//
//  OpenEarsEventsObserver.h
//  OpenEars
// 
//  OpenEarsEventsObserver is a class which allows the return of delegate methods delivering the status of various functions of Flite, Pocketsphinx and OpenEars
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  this file is licensed under the Politepix Shared Source license found 
//  found in the root of the source distribution. Please see the file "Version.txt" in the root of 
//  the source distribution for the version number of this OpenEars package.



// A protocol for delegates of OpenEarsEventsObserver.

@protocol OpenEarsEventsObserverDelegate;
/**
 @class  OpenEarsEventsObserver
 @brief  OpenEarsEventsObserver provides a large set of delegate methods that allow you to receive information about the events in OpenEars from anywhere in your app. You can create as many OpenEarsEventsObservers as you need and receive information using them simultaneously. All of the documentation for the use of OpenEarsEventsObserver is found in the section OpenEarsEventsObserverDelegate.
 
 */
@interface OpenEarsEventsObserver : NSObject { // All the action is in the delegate methods of this class.
/**To use the OpenEarsEventsObserverDelegate methods, assign this delegate to the class hosting OpenEarsEventsObserver and then use the delegate methods documented under OpenEarsEventsObserverDelegate. There is a complete example of how to do this explained under the OpenEarsEventsObserverDelegate documentation. */
	id<OpenEarsEventsObserverDelegate> delegate;
}

@property (assign) id<OpenEarsEventsObserverDelegate> delegate; // the delegate will be sent events.

@end
/**
 @protocol  OpenEarsEventsObserverDelegate
 @brief  OpenEarsEventsObserver provides a large set of delegate methods that allow you to receive information about the events in OpenEars from anywhere in your app. You can create as many OpenEarsEventsObservers as you need and receive information using them simultaneously.
 
 ## Usage examples
 > What to add to your header:
 @htmlinclude OpenEarsEventsObserver_Header.txt
 > What to add to your implementation:
 @htmlinclude OpenEarsEventsObserver_Implementation.txt
 > How to use the class methods:
 @htmlinclude OpenEarsEventsObserver_Calls.txt 
 
 */
@protocol OpenEarsEventsObserverDelegate <NSObject>

@optional 

// Delegate Methods you can implement in your app.

// Audio Session Status Methods.
/** There was an interruption.*/
- (void) audioSessionInterruptionDidBegin; 
/** The interruption ended.*/
- (void) audioSessionInterruptionDidEnd; 
/** The input became unavailable.*/
- (void) audioInputDidBecomeUnavailable; 
/** The input became available again.*/
- (void) audioInputDidBecomeAvailable; 
 /** The audio route changed.*/
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute;

// Pocketsphinx Status Methods.

/** Pocketsphinx isn't listening yet but it started calibration.*/
- (void) pocketsphinxDidStartCalibration; 
/** Pocketsphinx isn't listening yet but calibration completed.*/
- (void) pocketsphinxDidCompleteCalibration; 
/** Pocketsphinx isn't listening yet but it has entered the main recognition loop.*/
- (void) pocketsphinxRecognitionLoopDidStart; 
/** Pocketsphinx is now listening.*/
- (void) pocketsphinxDidStartListening;
 /** Pocketsphinx heard speech and is about to process it.*/
- (void) pocketsphinxDidDetectSpeech;
/** Pocketsphinx detected a second of silence indicating the end of an utterance*/
- (void) pocketsphinxDidDetectFinishedSpeech; 
/** Pocketsphinx has a hypothesis.*/
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID; 
 /** Pocketsphinx has an n-best hypothesis dictionary.*/
- (void) pocketsphinxDidReceiveNBestHypothesisArray:(NSArray *)hypothesisArray;
/** Pocketsphinx has exited the continuous listening loop.*/
- (void) pocketsphinxDidStopListening; 
 /** Pocketsphinx has not exited the continuous listening loop but it will not attempt recognition.*/
- (void) pocketsphinxDidSuspendRecognition;
 /** Pocketsphinx has not existed the continuous listening loop and it will now start attempting recognition again.*/
- (void) pocketsphinxDidResumeRecognition;
 /** Pocketsphinx switched language models inline.*/
- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString;
/** Some aspect of setting up the continuous loop failed, turn on OpenEarsLogging for more info.*/
- (void) pocketSphinxContinuousSetupDidFail; 

// Flite Status Methods.
/** Flite started speaking. You probably don't have to do anything about this.*/
- (void) fliteDidStartSpeaking; 
/** Flite finished speaking. You probably don't have to do anything about this.*/
- (void) fliteDidFinishSpeaking; 
	
@end
