#import "CameraControlAppDelegate.h"


@implementation CameraControlAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {		
	videoDevice = [[QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeVideo] objectAtIndex:0];
	[videoDevice open:nil];
	
	if( !videoDevice ) {
		NSLog( @"No video input device" );
		exit( 1 );
	}
	
	videoInput = [[QTCaptureDeviceInput alloc] initWithDevice:videoDevice];
	
	captureSession = [[QTCaptureSession alloc] init];
	[captureSession addInput:videoInput error:nil];	
	[captureSession startRunning];
	
	[captureView setCaptureSession:captureSession];
	[captureView setVideoPreviewConnection:[[captureView availableVideoPreviewConnections] objectAtIndex:0]];
	
	
	// Setting a lower resolution for the CaptureOutput here, since otherwise QTCaptureView
	// pulls full-res frames from the camera, which is slow. This is just for cosmetics.
	NSDictionary * pixelBufferAttr = [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithInt:640], kCVPixelBufferWidthKey,
									  [NSNumber numberWithInt:480], kCVPixelBufferHeightKey, nil];
	[[[captureSession outputs] objectAtIndex:0] setPixelBufferAttributes:pixelBufferAttr];
	
	
	
	
	// Ok, this might be all kinds of wrong, but it was the only way I found to map a 
	// QTCaptureDevice to a IOKit USB Device. The uniqueID method seems to always(?) return 
	// the locationID as a HEX string in the first few chars, but the format of this string 
	// is not documented anywhere and (knowing Apple) might change sooner or later.
	//
	// In most cases you'd be probably better of using the UVCCameraControls
	// - (id)initWithVendorID:(long) productID:(long) 
	// method instead. I.e. for the Logitech QuickCam9000:
	// cameraControl = [[UVCCameraControl alloc] initWithVendorID:0x046d productID:0x0990];
	//
	// You can use USB Prober (should be in /Developer/Applications/Utilities/USB Prober.app) 
	// to find the values of your camera.
	
	UInt32 locationID = 0;
	sscanf( [[videoDevice uniqueID] UTF8String], "0x%8x", &locationID );
	cameraControl = [[UVCCameraControl alloc] initWithLocationID:locationID];
	
	[cameraControl setAutoExposure:YES];
	[cameraControl setAutoWhiteBalance:YES];
}


- (IBAction)sliderMoved:(id)sender {
	
	// Exposure Time
	if( [sender isEqualTo:exposureSlider] ) {		
		[cameraControl setExposure:exposureSlider.floatValue];
	}
	
	// White Balance Temperature
	else if( [sender isEqualTo:whiteBalanceSlider] ) {
		[cameraControl setWhiteBalance:whiteBalanceSlider.floatValue];
	}
	
	// Gain Value
	else if( [sender isEqualTo:gainSlider] ) {
		[cameraControl setBrightness:gainSlider.floatValue];
	}
}


- (IBAction)checkBoxChanged:(id)sender {
	
	// Auto Exposure
	if( [sender isEqualTo:autoExposureCheckBox] ) {
		if( autoExposureCheckBox.state == NSOnState ) {
			[cameraControl setAutoExposure:YES];
			[exposureSlider setEnabled:NO];
		} 
		else {
			[cameraControl setAutoExposure:NO];
			[exposureSlider setEnabled:YES];
			[cameraControl setExposure:exposureSlider.floatValue];
		}
	}
	
	// Auto White Balance
	else if( [sender isEqualTo:autoWhiteBalanceCheckBox] ) {
		if( autoWhiteBalanceCheckBox.state == NSOnState ) {
			[cameraControl setAutoWhiteBalance:YES];
			[whiteBalanceSlider setEnabled:NO];
		} 
		else {
			[cameraControl setAutoWhiteBalance:NO];
			[whiteBalanceSlider setEnabled:YES];
			[cameraControl setWhiteBalance:whiteBalanceSlider.floatValue];
		}
	}
}


- (void)dealloc {
	[captureSession release];
	[videoInput release];
	[videoDevice release];
	
	[cameraControl release];
	[super dealloc];
}

@end

