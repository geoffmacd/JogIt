//  OpenEars 
//  http://www.politepix.com/openears
//
//  AudioQueueFallback.h
//  OpenEars
//
//  AudioQueueFallback is a class which simulates speech recognition on the Simulator since the low-latency audio unit driver doesn't work on the Simulator. 
//  Please do not ever make a bug report about this driver; it is only here as a convenience for you so that you can test recognition logic in the Simulator,
//  but it is not the supported driver for OpenEars and using it gives you no information about the performance or behavior of the actual OpenEars audio driver.
//
//  This is a sphinx ad based on modifications to the Sphinxbase template file ad_base.c.
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012 excepting that which falls under the copyright of Carnegie Mellon University
//  as part of their file ad_base.c
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  Excepting that which falls under the license of Carnegie Mellon University as part of their file ad_base.c,
//  this file is licensed under the Politepix Shared Source license found 
//  found in the root of the source distribution. Please see the file "Version.txt" in the root of 
//  the source distribution for the version number of this OpenEars package.

//
//  Header for original source file ad_base.c which I modified to create this driver is as follows:
//
/* -*- c-basic-offset: 4; indent-tabs-mode: nil -*- */
/* ====================================================================
 * Copyright (c) 1999-2001 Carnegie Mellon University.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer. 
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * This work was supported in part by funding from the Defense Advanced 
 * Research Projects Agency and the National Science Foundation of the 
 * United States of America, and the CMU Sphinx Speech Consortium.
 *
 * THIS SOFTWARE IS PROVIDED BY CARNEGIE MELLON UNIVERSITY ``AS IS'' AND 
 * ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL CARNEGIE MELLON UNIVERSITY
 * NOR ITS EMPLOYEES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ====================================================================
 *
 */

/*
 * ad.c -- Wraps a "sphinx-II standard" audio interface around the basic audio
 * 		utilities.
 *
 * HISTORY
 * 
 * 11-Jun-96	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University.
 * 		Modified to conform to new A/D API.
 * 
 * 12-May-96	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University.
 * 		Dummy template created.
 */
/**\cond HIDDEN_SYMBOLS*/
#if defined TARGET_IPHONE_SIMULATOR && TARGET_IPHONE_SIMULATOR

#ifndef _AD_H_
#define _AD_H_

#import <AudioToolbox/AudioToolbox.h> 
#import "prim_type.h"
#define kNumberOfChunksInRingbufferAudioQueue 28
#define kChunkSizeInBytesAudioQueue 16192 * 3

typedef struct Chunk { // The audio device struct used by Pocketsphinx.
	SInt16 *buffer; // The buffer of SInt16 samples
	SInt32 numberOfSamples; // The number of samples in the buffer
	CFAbsoluteTime writtenTimestamp; // When this buffer was written
} RingBuffer;	

typedef struct { // The audio device struct used by Pocketsphinx.
	AudioQueueRef audioQueue; // The Audio Queue.
	AudioQueueBufferRef audioQueueBuffers[3]; // The buffer array of the Audio Queue, 3 buffers is standard for Core Audio. 
	CFStringRef currentRoute; // The current Audio Route for the device (e.g. headphone mic or external mic).
	SInt64 recordPacket; // The current packet of the Audio Queue.
	AudioStreamBasicDescription audioQueueRecordFormat; // The recording format of the Audio Queue. 
	AudioQueueLevelMeterState *levelMeterState; // decibel metering of input.
	BOOL recordData; // Should data be recorded?
	BOOL recognitionIsInProgress; // Is the recognition loop in effect?
	BOOL audioQueueIsRunning; // Is the queue instantiated? 
	BOOL recording; // Is the Audio Queue currently recording sound? 
	SInt32 sps;		// Samples per second.
	SInt32 bps;		// Bytes per sample.
	RingBuffer ringBuffer[kNumberOfChunksInRingbufferAudioQueue];
	SInt16 indexOfLastWrittenChunk;
	SInt16 indexOfChunkToRead;
	CFAbsoluteTime consumedTimeStamp[kNumberOfChunksInRingbufferAudioQueue];
	BOOL calibrating;
	SInt16 *calibrationBuffer;
	UInt32 availableSamplesDuringCalibration;
	UInt32 samplesReadDuringCalibration;
	SInt16 roundsOfCalibration;
	BOOL extraSamples;
	UInt32 numberOfExtraSamples;
	SInt16 *extraSampleBuffer;
	BOOL endingLoop;
} PocketsphinxAudioDevice;	

void clear_buffers();
Float32 pocketsphinxAudioDeviceMeteringLevel(PocketsphinxAudioDevice * audioDriver); // Function which returns the metering level of the AudioQueue input.
PocketsphinxAudioDevice *openAudioDevice (const char *audioDevice, SInt32 samplesPerSecond); // Function to open the "audio device" or in this case instantiate a new Audio Queue.
SInt32 startRecordingWithLeader(PocketsphinxAudioDevice * audioDevice); // An optional function that starts Audio Queue recording after a second and a half so that calibration can happen with full buffers.
SInt32 startRecording(PocketsphinxAudioDevice * audioDevice); // Tell the Audio Queue to start recording.
SInt32 stopRecording(PocketsphinxAudioDevice * audioDevice); // Tell the Audio Queue to stop recording.
int32 readBufferContents(PocketsphinxAudioDevice * audioDevice, int16 * buffer, int32 maximum); // Scan the buffer for speech.
SInt32 closeAudioDevice(PocketsphinxAudioDevice * audioDevice); // Close the "audio device" or in this case stop and free the Audio Queue.
void AudioQueueInputBufferCallback(void *inUserData,
								   AudioQueueRef inAudioQueue,
								   AudioQueueBufferRef inBuffer,
								   const AudioTimeStamp *inStartTime,
								   UInt32 inNumberOfPackets,
								   const AudioStreamPacketDescription *inPacketDescription);

#endif
#else
#endif
/**\endcond*/
