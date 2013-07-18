//  OpenEars 
//  http://www.politepix.com/openears
//
//  PocketsphinxRunConfig.h
//  OpenEars
//
//  PocketsphinxRunConfig.h exposes all of the available options that Pocketsphinx can theoretically run with. 
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  this file is licensed under the Politepix Shared Source license found 
//  found in the root of the source distribution. Please see the file "Version.txt" in the root of 
//  the source distribution for the version number of this OpenEars package.

/**\cond HIDDEN_SYMBOLS*/

#import "AudioConstants.h"

// This is the config file for all of the Pocketsphinx run options. This is included as a convenience for development 
// and to make OpenEars suitable for use by research projects that may have a very good reason to get under the hood 
// here. However, absolutely no testing is done on OpenEars using settings below other than the shipping defaults, so 
// it unfortunately won't be possible to offer support for issues arising from making any changes to this file.  
//
// In short, you'll already know beyond a doubt whether you need to change anything here and you'll also know where to 
// ask if it doesn't work out, and understand why I can't help in that case.  You're welcome to get in touch and let me 
// know if something isn't working here that you think probably ought to be working, but I might not have the bandwidth 
// to respond or look into it.
//
// Please note that not every option has an effect on the OpenEars implementation of Pocketsphinx, a few of them if enabled 
// are likely to break OpenEars, and several of the options may be overriden by whatever hmm you choose to use, making 
// them unnecessary or pointless to set here.
//
// In order to use a setting below, uncomment the line it's on and replace the value that is between the @"" quotes with 
// the value you'd like to use.  The only exception to this is -hmm, which just needs to be uncommented since it's required 
// that all hmm files are sought inside the bundle and there is no specific filename that is targeted (unlike in the case 
// of the lm and dict files).




//#define kADCDEV @"null" // -adcdev	Name of audio device to use for input, unused by OpenEars
//#define kAGC @"null" // -agc	Automatic gain control for c0 ('max', 'emax', 'noise', or 'none'), defaults to none
//#define kAGCTHRESH @"null" // -agcthresh	Initial threshold for automatic gain control, defaults to 2.0
//#define kALPHA @"null" // -alpha	Preemphasis parameter, defaults to 0.97
//#define kASCALE @"null" // -ascale	Inverse of acoustic model scale for confidence score calculation, defaults to 20.0
//#define kBACKTRACE @"null" // -backtrace	Print results and backtraces to log file, defaults to no
//#define kBEAM @"null" // -beam	Beam width applied to every frame in Viterbi search (smaller values mean wider beam), defaults to 1e-48
//#define kBESTPATH @"yes" // -bestpath	Run bestpath (Dijkstra) search over word lattice (3rd pass), defaults to yes
//#define kBESTPATHLW @"null" // -bestpathlw	Language model probability weight for bestpath search, defaults to 9.5
//#define kBGHIST @"null" // -bghist	Bigram-mode: If TRUE only one BP entry/frame; else one per LM state, defaults to no
//#define kCEPLEN @"null" // -ceplen	Number of components in the input feature vector, defaults to 13
//#define kCMN @"null" // -cmn	Cepstral mean normalization scheme ('current', 'prior', or 'none'), defaults to current
//#define kCMNINIT @"null" // -cmninit	Initial values (comma-separated) for cepstral mean when 'prior' is used, defaults to 8.0
//#define kCOMPALLSEN @"null" // -compallsen	Compute all senone scores in every frame (can be faster when there are many senones), defaults to no
//#define kDEBUG @"null" // -debug	Verbosity level for debugging messages
#define kDICT kDictionaryName // -dict	Main pronunciation dictionary (lexicon) input file
//#define kDICTCASE @"null" // -dictcase	Dictionary is case sensitive (NOTE: case insensitivity applies to ASCII characters only), defaults to no
//#define kDITHER @"null" // -dither	Add 1/2-bit noise, defaults to no
//#define kDOUBLEBW @"null" // -doublebw	Use double bandwidth filters (same center freq), defaults to no
//#define kDS @"2" // -ds	Frame GMM computation downsampling ratio, defaults to 1
//#define kFDICT // -fdict	Noise word pronunciation dictionary input file
//#define kFEAT @"null" // -feat	Feature stream type, depends on the acoustic model, defaults to 1s_c_d_dd
//#define kFEATPARAMS @"null" // -featparams	File containing feature extraction parameters.
//#define kFILLPROB @"null" // -fillprob	Filler word transition probability, defaults to 1e-8
//#define kFRATE @"null" // -frate	Frame rate, defaults to 100
//#define kFSG @"null" // -fsg	Sphinx format finite state grammar file
//#define kFSGUSEALTPRON @"null" // -fsgusealtpron	Add alternate pronunciations to FSG, defaults to yes
//#define kFSGUSEFILLER @"null" // -fsgusefiller	Insert filler words at each state., defaults to yes
//#define kFWDFLAT @"null" // -fwdflat	Run forward flat-lexicon search over word lattice (2nd pass), defaults to yes
//#define kFWDFLATBEAM @"null" // -fwdflatbeam	Beam width applied to every frame in second-pass flat search, defaults to 1e-64
//#define kFWDFLATWID @"null" // -fwdflatefwid	Minimum number of end frames for a word to be searched in fwdflat search, defaults to 4
//#define kFWDFLATLW @"null" // -fwdflatlw	Language model probability weight for flat lexicon (2nd pass) decoding, defaults to 8.5
//#define kFWDFLATSFWIN @"null" // -fwdflatsfwin	Window of frames in lattice to search for successor words in fwdflat search , defaults to 25
//#define kFWDFLATWBEAM @"null" // -fwdflatwbeam	Beam width applied to word exits in second-pass flat search, defaults to 7e-29
//#define kFWDTREE @"null" // -fwdtree	Run forward lexicon-tree search (1st pass), defaults to yes
#define kHMM // -hmm	Directory containing acoustic model files.
//#define kINPUT_ENDIAN @"null" // -input_endian	Endianness of input data, big or little, ignored if NIST or MS Wav, defaults to little
#define kJSGF kJSGFName // -jsgf	JSGF grammar file
//#define kKDMAXBBI @"null" // -kdmaxbbi	Maximum number of Gaussians per leaf node in kd-Trees, defaults to -1
//#define kKDMAXDEPTH @"7" // -kdmaxdepth	Maximum depth of kd-Trees to use, defaults to 0
//#define kKDTREE @"null" // -kdtree	kd-Tree file for Gaussian selection
//#define kLATSIZE @"null" // -latsize	Initial backpointer table size, defaults to 5000
//#define kLDA @"null" // -lda	File containing transformation matrix to be applied to features (single-stream features only)
//#define kLDADIM @"null" // -ldadim	Dimensionality of output of feature transformation (0 to use entire matrix), defaults to 0
//#define kLEXTREEDUMP @"null" // -lextreedump	Whether to dump the lextree structure to stderr (for debugging), 1 for Ravi's format, 2 for Dot format, Larger than 2 will be treated as Ravi's format, defaults to 0
//#define kLIFTER @"null" // -lifter	Length of sin-curve for liftering, or 0 for no liftering, defaults to 0
#define kLM kLanguageModelName // -lm	Word trigram language model input file
//#define kLMCTL @"null" // -lmctl	Specify a set of language model
//#define kLMNAME @"null" // -lmname	Which language model in -lmctl to use by default, defaults to default
//#define kLOGBASE @"null" // -logbase	Base in which all log-likelihoods calculated, defaults to 1.0001
//#define kLOGFN @"null" // -logfn	File to write log messages in
//#define kLOGSPEC @"null" // -logspec	Write out logspectral files instead of cepstra, defaults to no
//#define kLOWERF @"null" // -lowerf	Lower edge of filters, defaults to 133.33334
//#define kLPBEAM @"null" // -lpbeam	Beam width applied to last phone in words, defaults to 1e-40
//#define kLPONLYBEAM @"null" // -lponlybeam	Beam width applied to last phone in single-phone words, defaults to 7e-29
//#define kLW @"null" // -lw	Language model probability weight, defaults to 6.5
#define kMAXHMMPF @"3000" // -maxhmmpf	Maximum number of active HMMs to maintain at each frame (or -1 for no pruning), defaults to -1
//#define kMAXNEWOOV @"null" // -maxnewoov	Maximum new OOVs that can be added at run time, defaults to 20
//#define kMAXWPF @"5" // -maxwpf	Maximum number of distinct word exits at each frame (or -1 for no pruning), defaults to -1
//#define kMDEF @"null" // -mdef	Model definition input file
//#define kMEAN @"null" // -mean	Mixture gaussian means input file
//#define kMFCLOGDIR @"null" // -mfclogdir	Directory to log feature files to
//#define kMIXW @"null" // -mixw	Senone mixture weights input file (uncompressed)
//#define kMIXWFLOOR @"null" // -mixwfloor	Senone mixture weights floor (applied to data from -mixw file), defaults to 0.0000001
//#define kMLLR @"null" // -mllr	MLLR transformation to apply to means and variances
//#define kMMAP @"null" // -mmap	Use memory-mapped I/O (if possible) for model files, defaults to yes
//#define kNCEP @"null" // -ncep	Number of cep coefficients, defaults to 13
//#define kNFFT @"null" // -nfft	Size of FFT, defaults to 512
//#define kNFILT @"null" // -nfilt	Number of filter banks, defaults to 40
//#define kNWPEN @"null" // -nwpen	New word transition penalty, defaults to 1.0
//#define kPBEAM @"null" // -pbeam	Beam width applied to phone transitions, defaults to 1e-48
//#define kPIP @"null" // -pip	Phone insertion penalty, defaults to 1.0
//#define kPL_BEAM @"null" // -pl_beam	Beam width applied to phone loop search for lookahead, defaults to 1e-10
//#define kPL_PBEAM @"null" // -pl_pbeam	Beam width applied to phone loop transitions for lookahead, defaults to 1e-5
//#define kPL_WINDOW @"null" // -pl_window	Phoneme lookahead window size, in frames, defaults to 0
//#define kRAWLOGDIR @"null" // -rawlogdir	Directory to log raw audio files to
//#define kREMOVE_DC @"null" // -remove_dc	Remove DC offset from each frame, defaults to no
//#define kROUND_FILTERS @"null" // -round_filters	Round mel filter frequencies to DFT points, defaults to yes
#define kSAMPRATE [NSString stringWithFormat:@"%d",kSamplesPerSecond] // -samprate	Sampling rate, defaults to 16000
//#define kSEED @"null" // -seed	Seed for random number generator; if less than zero, pick our own, defaults to -1
//#define kSENDUMP @"null" // -sendump	Senone dump (compressed mixture weights) input file
//#define kSENMGAU @"null" // -senmgau	Senone to codebook mapping input file (usually not needed)
//#define kSILPROB @"null" // -silprob	Silence word transition probability, defaults to 0.005
//#define kSMOOTHSPEC @"null" // -smoothspec	Write out cepstral-smoothed logspectral files, defaults to no
//#define kSVSPEC @"null" // -svspec	Subvector specification (e.g., 24,0-11/25,12-23/26-38 or 0-12/13-25/26-38)
//#define kTMAT @"null" // -tmat	HMM state transition matrix input file
//#define kTMATFLOOR @"null" // -tmatfloor	HMM state transition probability floor (applied to -tmat file), defaults to 0.0001
//#define kTOPN @"3" // -topn	Maximum number of top Gaussians to use in scoring., defaults to 4
//#define kTOPN_BEAM @"null" // -topn_beam	Beam width used to determine top-N Gaussians (or a list, per-feature), defaults to 0
//#define kTOPRULE @"null" // -toprule	Start rule for JSGF (first public rule is default)
//#define kTRANSFORM @"null" // -transform	Which type of transform to use to calculate cepstra (legacy, dct, or htk), defaults to legacy
//#define kUNIT_AREA @"null" // -unit_area	Normalize mel filters to unit area, defaults to yes
//#define kUPPERF @"null" // -upperf	Upper edge of filters, defaults to 6855.4976
//#define kUSEWDPHONES @"null" // -usewdphones	Use within-word phones only, defaults to no
//#define kUW @"null" // -uw	Unigram weight, defaults to 1.0
//#define kVAR @"null" // -var	Mixture gaussian variances input file
//#define kVARFLOOR @"null" // -varfloor	Mixture gaussian variance floor (applied to data from -var file), defaults to 0.0001
//#define kVARNORM @"null" // -varnorm	Variance normalize each utterance (only if CMN == current), defaults to no
//#define kVERBOSE @"null" // -verbose	Show input filenames, defaults to no
//#define kWARP_PARAMS @"null" // -warp_params	Parameters defining the warping function
//#define kWARP_TYPE @"null" // -warp_type	Warping function type (or shape), defaults to inverse_linear
//#define kWBEAM @"null" // -wbeam	Beam width applied to word exits, defaults to 7e-29
//#define kWIP @"null" // -wip	Word insertion penalty, defaults to 0.65
//#define kWLEN @"null" // -wlen	Hamming window length , defaults to 0.025625

/**\endcond */
