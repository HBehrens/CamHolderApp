#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>
#import "UVCCameraControl.h"
#import "CroppingQTCaptureView.h"

@interface CameraControlAppDelegate : NSObject {
	QTCaptureSession * captureSession;
	QTCaptureDevice * videoDevice;
	QTCaptureDeviceInput * videoInput;
	
	UVCCameraControl * cameraControl;
	NSArray *allDevices;
	
	IBOutlet CroppingQTCaptureView * captureView;
	
	IBOutlet NSComboBox * deviceCombobox;
	IBOutlet NSButton * autoExposureCheckBox;
	IBOutlet NSButton * autoWhiteBalanceCheckBox;
	IBOutlet NSButton * autoFocusCheckBox;
	IBOutlet NSSlider * exposureSlider;
	IBOutlet NSSlider * whiteBalanceSlider;
	IBOutlet NSSlider * gainSlider;
	IBOutlet NSSlider * focusSlider;
	IBOutlet NSScrollView *inspector;
	IBOutlet NSWindow *window;
	IBOutlet NSButton * resetZoomButton;
	IBOutlet NSView *zoomRectView;
	
	NSWindow *borderlessWindow;
	NSApplicationPresentationOptions originalPresentionOptions;
	
	float rotation;
	BOOL mirrorX, mirrorY;
	NSRect normalizedCroppingRect;
	
	int originalWindowStyleMask;
	BOOL didEnterFullscreenFromBorderless;
}

- (IBAction)sliderMoved:(id)sender;
- (IBAction)checkBoxChanged:(id)sender;
- (IBAction)deviceChanged:(id)sender;
- (IBAction)rotatePreview:(id)sender;
- (IBAction)toggleFullScreen:(id)sender;
- (IBAction)toggleBorderless:(id)sender;
- (IBAction)flipHorizontal:(id)sender;
- (IBAction)flipVertical:(id)sender;
- (IBAction)resetZoom:(id)sender;
	
@end
