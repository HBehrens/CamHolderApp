#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>
#import "UVCCameraControl.h"

@interface CameraControlAppDelegate : NSObject {
	QTCaptureSession * captureSession;
	QTCaptureDevice * videoDevice;
	QTCaptureDeviceInput * videoInput;
	
	UVCCameraControl * cameraControl;
	NSArray *allDevices;
	
	IBOutlet QTCaptureView * captureView;
	
	IBOutlet NSComboBox * deviceCombobox;
	IBOutlet NSButton * autoExposureCheckBox;
	IBOutlet NSButton * autoWhiteBalanceCheckBox;
	IBOutlet NSButton * autoFocusCheckBox;
	IBOutlet NSSlider * exposureSlider;
	IBOutlet NSSlider * whiteBalanceSlider;
	IBOutlet NSSlider * gainSlider;
	IBOutlet NSSlider * focusSlider;
	
	float rotation;
}

- (IBAction)sliderMoved:(id)sender;
- (IBAction)checkBoxChanged:(id)sender;
- (IBAction)deviceChanged:(id)sender;
- (IBAction)rotatePreview:(id)sender;

@end
