

#import <MapKit/MapKit.h>

@interface KMAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D  kmCoord;
}


@property (nonatomic) CLLocationCoordinate2D kmCoord;

@property (nonatomic, strong) NSString *kmName;
@property (nonatomic, strong) NSString *paceString;

@end