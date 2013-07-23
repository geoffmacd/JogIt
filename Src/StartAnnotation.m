

#import "StartAnnotation.h"

@implementation StartAnnotation

@synthesize mileCoord,mileName,paceString;

- (CLLocationCoordinate2D)coordinate;
{
    return mileCoord;
}

- (NSString *)title
{
    return mileName;
}

// optional
- (NSString *)subtitle
{
    return paceString;
}

@end