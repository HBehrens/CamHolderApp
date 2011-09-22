#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>
#import "UVCCameraControl.h"

@interface CameraControlAppDelegate : NSObject {
	QTCaptureSession * captureSession;
	QTCaptureDevice * videoDevice;
	QTCaptureDeviceInput * videoInput;
	
	UVCCameraControl * cameraControl;
	
	IBOutlet QTCaptureView * captureView;
	
	IBOutlet NSButton * autoExposureCheckBox;
	IBOutlet NSButton * autoWhiteBalanceCheckBox;
	IBOutlet NSSlider * exposureSlider;
	IBOutlet NSSlider * whiteBalanceSlider;
	IBOutlet NSSlider * gainSlider;
}

- (IBAction)sliderMoved:(id)sender;
- (IBAction)checkBoxChanged:(id)sender;

@end
