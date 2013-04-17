

#import <MapKit/MapKit.h>

@interface FinishAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D  mileCoord;
}


@property (nonatomic) CLLocationCoordinate2D mileCoord;

@property (nonatomic, strong) NSString *mileName;
@property (nonatomic, strong) NSString *paceString;

@end