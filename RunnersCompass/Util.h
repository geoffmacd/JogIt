//
//  Util.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-03-13.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (UIImage *) imageWithView:(UIView *)view withSize:(CGSize)size;

@end

@interface UIImage (ImageBlur)
- (UIImage *)imageWithGaussianBlur9;
@end
