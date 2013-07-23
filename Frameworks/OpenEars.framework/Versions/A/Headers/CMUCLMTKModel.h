//
//  CMUCLMTKModel.h
//  OpenEars 
//  http://www.politepix.com/openears
//
//  CMUCLMTKModel is a class which abstracts the conversion of vocabulary into language models
//  OpenEars
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  this file is licensed under the Politepix Shared Source license found 
//  found in the root of the source distribution. Please see the file "Version.txt" in the root of 
//  the source distribution for the version number of this OpenEars package.
/**\cond HIDDEN_SYMBOLS*/

//#define KEEPFILES

@interface CMUCLMTKModel : NSObject {
    NSString *pathToDocumentsDirectory;
    int verbosity;
    NSString *algorithmType;
}

- (void) runCMUCLMTKOnCorpusFile:(NSString *)fileName withDMP:(BOOL)withDMP;
- (void) convertARPAAtPath:(NSString *)arpaFileName toDMPAtPath:(NSString *)dmpFileName;


@property (nonatomic, copy) NSString *pathToDocumentsDirectory;
@property (nonatomic, assign) int verbosity;
@property (nonatomic, copy) NSString *algorithmType;
@end
/**\endcond */
