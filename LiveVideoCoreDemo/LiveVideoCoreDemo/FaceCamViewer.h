//
//  FaceCamViewer.h
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum{
    IPHONE3x5 = 0,
    IPHONE4 = 1,
    IPAD = 2
} DeviceType;

@interface FaceCamViewer : UIView {
    CGPoint offset;
}

@property (nonatomic, assign) AVCaptureDevicePosition cameraType;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) BOOL draggable;

-(id)initWithDeviceType:(DeviceType)type;
-(void)startFaceCam;
@end
