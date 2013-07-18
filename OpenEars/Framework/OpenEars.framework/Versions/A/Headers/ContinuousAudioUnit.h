//  OpenEars 
//  http://www.politepix.com/openears
//
//  ContinuousAudioUnit.h
//  OpenEars
//
//  ContinuousAudioUnit is a class which handles the interaction between the Pocketsphinx continuous recognition loop and Core Audio.
//
//  Copyright Politepix UG 2012
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  this file is licensed under the Politepix Shared Source license found 
//  found in the root of the source distribution. Please see the file "Version.txt" in the root of 
//  the source distribution for the version number of this OpenEars package.

/**\cond HIDDEN_SYMBOLS*/
#if defined TARGET_IPHONE_SIMULATOR && TARGET_IPHONE_SIMULATOR // The simulator uses an audio queue driver because it doesn't work at all with the low-latency audio unit driver. 

#import "AudioQueueFallback.h"

#else // The real driver is the low-latency audio unit driver:

#define _AD_H_
#import <AudioToolbox/AudioToolbox.h>
//#include "sphinxbase_export.h"
#import "prim_type.h"
#import "AudioConstants.h"

//extern "C" {

typedef struct Chunk { // The audio device struct used by Pocketsphinx.
	SInt16 *buffer; // The buffer of SInt16 samples
	SInt32 numberOfSamples; // The number of samples in the buffer
	CFAbsoluteTime writtenTimestamp; // When this buffer was written
} RingBuffer;	
	
typedef struct {
	
	BOOL interruptionWasReceived;
	BOOL reactivatingAfterInterruption;
	AudioUnit audioUnit;
	AudioStreamBasicDescription thruFormat;
	int16 deviceIsOpen;
	int16 unitIsRunning;
	CFStringRef currentRoute; // The current Audio Route for the device (e.g. headphone mic or external mic).
	SInt64 recordPacket; // The current packet of the Audio unit.
	BOOL recordData; // Should data be recorded?
	BOOL recognitionIsInProgress; // Is the recognition loop in effect?
	BOOL audioUnitIsRunning; // Is the unit instantiated? 
	BOOL recording; // Is the Audio unit currently recording sound? 
	SInt32 sps;		// Samples per second.
	SInt32 bps;		// Bytes per sample.
	RingBuffer ringBuffer[kNumberOfChunksInRingbuffer]; // The ringbuffer
	SInt16 indexOfLastWrittenChunk; // The index of the ringbuffer section that was last written to
	SInt16 indexOfChunkToRead; // The index of the ringbuffer section that next needs reading
	CFAbsoluteTime consumedTimeStamp[kNumberOfChunksInRingbuffer]; // The ringbuffer section timestamp array
	BOOL calibrating; // let's classes interacting with this class get/set the state of whether the driver is calibrating
	SInt16 *calibrationBuffer; // The buffer of calibration samples
	UInt32 availableSamplesDuringCalibration; // The number of calibration samples that are available for reading
	UInt32 samplesReadDuringCalibration; // The number of calibration samples which have been read
	SInt16 roundsOfCalibration; // The number of calibration rounds
	BOOL extraSamples; // Are there extra samples to read beyond the ringbuffer (this is an adaptation to the pocketsphinx-required driver setup, which results in a chunk of extra samples after processing the main results of a recording round)
	UInt32 numberOfExtraSamples; // The number of extra samples to read
	SInt16 *extraSampleBuffer; // The buffer of extra samples to read
	BOOL endingLoop; // We do things slightly differently if we are trying to exit the continuous recognition loop
	Float32 pocketsphinxDecibelLevel; // The decibel level of mic input
	
	
} PocketsphinxAudioDevice;	

void clear_buffers();
Float32 pocketsphinxAudioDeviceMeteringLevel(PocketsphinxAudioDevice * audioDriver); // Returns the decibel level of mic input to controller classes
PocketsphinxAudioDevice *openAudioDevice(const char *dev, int32 samples_per_sec); // Opens the audio device
int32 startRecording(PocketsphinxAudioDevice * audioDevice); // Starts the audio device
int32 stopRecording(PocketsphinxAudioDevice * audioDevice); // Stops the audio device
int32 closeAudioDevice(PocketsphinxAudioDevice * audioDevice); // Closes the audio device
int32 readBufferContents(PocketsphinxAudioDevice * audioDevice, int16 * buffer, int32 maximum); // reads the buffer samples for speech data and silence data
void setRoute(); // Sets the audio route as read from the audio session manager
void getDecibels(SInt16 * samples, UInt32 inNumberFrames); // Reads the buffer samples and converts them to decibel readings

//}

#endif

/**\endcond */
