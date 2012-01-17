#import "CameraControlAppDelegate.h"
#import "BorderlessWindow.h"

@implementation CameraControlAppDelegate

-(void)connectToVideoDevice:(QTCaptureDevice*)device {
	[captureSession release];
	
	[[NSUserDefaults standardUserDefaults] setObject: [device uniqueID] forKey:@"deviceId"];

	videoDevice = device;
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
	captureView.delegate = self;
	captureView.canSelectRect = YES;
	
	
	// Setting a lower resolution for the CaptureOutput here, since otherwise QTCaptureView
	// pulls full-res frames from the camera, which is slow. This is just for cosmetics.
	
	// NOTE: for Logitech QuickCam Pro 9000 Webcam everythin >=1280 or > 720  puts camera into widescreen
	NSDictionary * pixelBufferAttr = [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithInt:1280], kCVPixelBufferWidthKey,
									  [NSNumber numberWithInt:720], kCVPixelBufferHeightKey, nil];
	[[[captureSession outputs] objectAtIndex:0] setPixelBufferAttributes:pixelBufferAttr];
	
	
	
	
	// Ok, this might be all kinds of wrong, but it was the only way I found to map a 
	// QTCaptureDevice to a IOKit USB Device. The uniqueID method seems to always(?) return 
	// the locationID as a HEX string in the first few chars, but the format of this string 
	// is not documented anywhere and (knowing Apple) might change sooner or later.
	//
	// In most cases you'd be probably better of using the UVCCameraControls
	// - (id)initWithVendorID:(long) productID:(long) 
	// method instead. I.e. for the Logitech QuickCam9000 
	// cameraControl = [[UVCCameraControl alloc] initWithVendorID:0x046d productID:0x0990];
	//
	// You can use USB Prober (should be in /Developer/Applications/Utilities/USB Prober.app) 
	// to find the values of your camera.
	
	UInt32 locationID = 0;
	sscanf( [[videoDevice uniqueID] UTF8String], "0x%8x", (unsigned int*)&locationID );
	cameraControl = [[UVCCameraControl alloc] initWithLocationID:locationID];
	
	[cameraControl setAutoExposure:YES];
	[cameraControl setAutoWhiteBalance:YES];
	[cameraControl setAutoFocus:YES];
}

-(NSString*)selectedDeviceId {
	int idx = [deviceCombobox indexOfSelectedItem];
	if(idx >= 0 && idx < [allDevices count])
		return [(QTCaptureDevice*)[allDevices objectAtIndex: idx] uniqueID];
	return nil;
}

-(void)setSelectedDeviceId:(NSString*)id {
	QTCaptureDevice* device = [QTCaptureDevice deviceWithUniqueID:id];
	if(device) {
		int idx = [allDevices indexOfObject:device];
		[deviceCombobox selectItemAtIndex: idx];
	} else {
		if([deviceCombobox numberOfItems] > 0) {
			[deviceCombobox selectItemAtIndex: 0];
		}
	}
}

-(NSArray*)allSuitableDevices {
	static NSString* suitableModelUniqueID = @"UVC Camera VendorID_1118 ProductID_1906";
	NSArray *unfiltered = [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeVideo];
	NSMutableArray *result = [NSMutableArray array];
	for(QTCaptureDevice *d in unfiltered) {
		if([suitableModelUniqueID isEqualToString:[d modelUniqueID]])
			[result addObject: d];
	}
	return result;
}

-(void)populateDevices {
	NSString *selected = [self selectedDeviceId];
	if(!selected)
		selected = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceId"];
	
	[allDevices release];
	allDevices = [[self allSuitableDevices] copy];
	
	[deviceCombobox removeAllItems];
	for (QTCaptureDevice* d in allDevices) {
		[deviceCombobox addItemWithObjectValue: [d localizedDisplayName]];
	}
	
	[self setSelectedDeviceId: selected];
	[self deviceChanged:deviceCombobox];
	
	if([self selectedDeviceId] == nil) {
		NSAlert *alert = [NSAlert alertWithMessageText:@"Camera not found" 
										 defaultButton:nil alternateButton:nil otherButton:nil 
							 informativeTextWithFormat:@"Make sure to attach at least one camera of the model 'Microsoft LifeCam Studio' before running this application."];
		[alert runModal];
		[[NSApplication sharedApplication] terminate:self];
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {		
	[self populateDevices];
	originalWindowStyleMask = [window styleMask];
}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
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
	
	// Focus Value
	else if( [sender isEqualTo:focusSlider] ) {
		[cameraControl setAbsoluteFocus:focusSlider.floatValue];
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
	
	// Auto Focus
	else if( [sender isEqualTo:autoFocusCheckBox] ) {
		if( autoFocusCheckBox.state == NSOnState ) {
			[cameraControl setAutoFocus:YES];
			[focusSlider setEnabled:NO];
		} 
		else {
			[cameraControl setAutoFocus:NO];
			[focusSlider setEnabled:YES];
			[cameraControl setAbsoluteFocus:focusSlider.floatValue];
		}
	}
	
}

-(IBAction)deviceChanged:(id)sender {
	QTCaptureDevice *device = [QTCaptureDevice deviceWithUniqueID:[self selectedDeviceId]];
	if(device)
		[self connectToVideoDevice:device];
}

- (void)dealloc {
	[captureSession release];
	[videoInput release];
	[videoDevice release];
	
	[cameraControl release];
	[allDevices release];
	[super dealloc];
}

#pragma mark -
#pragma mark Image Transformation

-(void)viewWillSelectRect:(QTCaptureView *)view {
	mirrorX = NO;
	mirrorY = NO;
	rotation = 0;
//	normalizedCroppingRect = NSZeroRect;
}


-(void)view:(QTCaptureView *)view didSelectRect:(NSRect)rect {
	
	if(NSEqualRects(NSZeroRect, normalizedCroppingRect)) {
		normalizedCroppingRect = rect;
	} else {
		float w = normalizedCroppingRect.size.width;
		float h = normalizedCroppingRect.size.height;
		
		normalizedCroppingRect = NSMakeRect(
											normalizedCroppingRect.origin.x + w*rect.origin.x,
											normalizedCroppingRect.origin.y + h*rect.origin.y,
											w*rect.size.width,
											h*rect.size.height
											);
		
	}
	[resetZoomButton setEnabled: YES];
	
	// TODO: apply transformation
}

- (IBAction)resetZoom:(id)sender {
	normalizedCroppingRect = NSZeroRect;
	[resetZoomButton setEnabled: NO];
}

- (CIImage *)view:(QTCaptureView *)view willDisplayImage:(CIImage*)image {
	if(!NSEqualRects(NSZeroRect, normalizedCroppingRect)) {
		float w = image.extent.size.width;
		float h = image.extent.size.height;
		CGRect transformedCrop = NSRectToCGRect(normalizedCroppingRect);
		transformedCrop.origin.x *= w;
		transformedCrop.origin.y *= h;
		transformedCrop.size.width *= w;
		transformedCrop.size.height *= h;
		
		image = [image imageByCroppingToRect:transformedCrop];
	}
	
	float scaleX = mirrorX ? -1 : 1;
	float scaleY = mirrorY ? -1 : 1;
	
	return [image
			imageByApplyingTransform:CGAffineTransformScale(
															CGAffineTransformMakeRotation(rotation * M_PI /180.0),
															scaleX, scaleY)
			];
}

- (IBAction)rotatePreview:(id)sender {
	NSMenuItem *i = sender;
	rotation = (int)(rotation + i.tag) % 360;
	while(rotation<0)rotation+=360;
}

- (IBAction)flipHorizontal:(id)sender {
	mirrorX = !mirrorX;
}

- (IBAction)flipVertical:(id)sender {
	mirrorY = !mirrorY;
}
								  
#pragma mark -
#pragma mark Full Screen Behavior
														  
-(void)realignCaptureView {
	NSRect r = [window.contentView bounds];
	r.size.width -= inspector.frame.size.width;
	captureView.frame = r;
}

-(NSRect)frameWindowAfterHidingBorderless {
	if(![borderlessWindow isZoomed]) {
		NSRect r = [window frameRectForContentRect:borderlessWindow.frame];
		r.size.width += inspector.frame.size.width;
		return r;
	} else {
		return window.frame;
	}
}

-(NSRect)borderlessFrameFromWindowFrame {
	NSRect r = [window contentRectForFrameRect:window.frame];
	r.size.width -= inspector.frame.size.width;
	r.origin = window.frame.origin;
	return r;
}

- (IBAction)toggleFullScreen:(id)sender {
	// gosh, this code needs refactoring!
	NSApplication *app = [NSApplication sharedApplication];
	
	if(didEnterFullscreenFromBorderless) {
		[borderlessWindow setFrame: [self borderlessFrameFromWindowFrame] display:NO];
		didEnterFullscreenFromBorderless = NO;
		[app setPresentationOptions:originalPresentionOptions];
		return;
	}
	
	didEnterFullscreenFromBorderless = borderlessWindow && ![borderlessWindow isZoomed];
	if(!didEnterFullscreenFromBorderless) {
		[self toggleBorderless:sender];
	}
	
	if(borderlessWindow) {
		NSScreen *targetScreen = borderlessWindow.screen ? borderlessWindow.screen : window.screen;
		[window setFrame:[self frameWindowAfterHidingBorderless] display:NO];
		[borderlessWindow setFrame:targetScreen.frame display: NO];
		[app setPresentationOptions:NSApplicationPresentationHideDock | NSApplicationPresentationHideMenuBar];
	} else {
		[app setPresentationOptions:originalPresentionOptions];
	}
}

- (IBAction)toggleBorderless:(id)sender {
	if(!borderlessWindow) {
		NSRect r = [self borderlessFrameFromWindowFrame];
		borderlessWindow = [[BorderlessWindow alloc] initWithContentRect:r
													   styleMask:NSBorderlessWindowMask
														 backing:NSBackingStoreBuffered
														   defer:NO screen:nil];
		[borderlessWindow setContentView:captureView];
		[borderlessWindow makeKeyAndOrderFront:nil];
		[window orderOut:nil];
	} else {
		[window setFrame:[self frameWindowAfterHidingBorderless] display:NO];
		[window.contentView addSubview:captureView];
		[self realignCaptureView];
		[window orderFront:nil];
		[window makeKeyAndOrderFront:nil];
		[borderlessWindow release];
		borderlessWindow = nil;
	}
	captureView.canSelectRect = borderlessWindow == nil;
}

@end

