

#import "KMAnnotation.h"

@implementation KMAnnotation

@synthesize kmCoord,kmName,paceString;

- (CLLocationCoordinate2D)coordinate;
{
    return kmCoord;
}

- (NSString *)title
{
    return kmName;
}

// optional
- (NSString *)subtitle
{
    return paceString;
}

@end