//  OpenEars 
//  http://www.politepix.com/openears
//
//  AudioConstants.h
//  OpenEars
// 
//  AudioConstants is a class which sets constants controlling audio behavior that are used in many places in the API. To control the ringbuffer, it's sufficient to interact with kBufferLength only.
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  this file is licensed under the Politepix Shared Source license found 
//  found in the root of the source distribution. Please see the file "Version.txt" in the root of 
//  the source distribution for the version number of this OpenEars package.

/**\cond HIDDEN_SYMBOLS*/
#import "RuntimeValues.h"

extern int input_sample_rate;

#define kSamplesPerSecond input_sample_rate
#define kBufferLength 0.12800 // This is the size of the audio unit buffer in seconds. Not as short as Audio Units can be, but we need a fairly large chunk of samples for the read function or it will be difficult for the ringbuffer to stay ahead of it.
#define kPredictedSizeOfRenderFramesPerCallbackRound kBufferLength * kSamplesPerSecond // This is the expected number of frames per callback
#define kMaxFrames kPredictedSizeOfRenderFramesPerCallbackRound * 4 // Let's cap the max frames allowed at 4x the expected frames so weird circumstances don't overrun the buffers

#define kNumberOfChunksInRingbuffer 14 // How many sections the ringbuffer has
#define kChunkSizeInBytes kPredictedSizeOfRenderFramesPerCallbackRound * 5 // The size of an individual section, which is the predicted callback size * 5 to allow the maximum allowed frames and a little extra

#define kExtraSampleBufferSize kSamplesPerSecond * 2 // Let's just make this 2 seconds long. It's likely to be far less.

#define kLowPassFilterTimeSlice .001 // For calculating decibel levels
#define kDBOffset -120.0 // This is the negative offset for calculating decibel levels

/**\endcond */
