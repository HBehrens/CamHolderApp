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
	IBOutlet NSButton * autoFocusCheckBox;
	IBOutlet NSSlider * exposureSlider;
	IBOutlet NSSlider * whiteBalanceSlider;
	IBOutlet NSSlider * gainSlider;
	IBOutlet NSSlider * focusSlider;
}

- (IBAction)sliderMoved:(id)sender;
- (IBAction)checkBoxChanged:(id)sender;

@end
