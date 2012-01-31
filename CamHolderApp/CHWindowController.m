//
//  CHWindowController.m
//  CamHolderApp
//
//  Created by Heiko Behrens on 31.01.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "CHWindowController.h"
#import <QTKit/QTKit.h>

@implementation CHWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [captureDevicesCombobox removeAllItems];
	for (QTCaptureDevice* d in self.document.captureDevices) {
		[captureDevicesCombobox addItemWithObjectValue: [d localizedDisplayName]];
	}
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Camera Handling

-(void)connectToVideoDevice:(QTCaptureDevice*)device {
	[_captureSession release];
	
//	[[NSUserDefaults standardUserDefaults] setObject: [device uniqueID] forKey:@"deviceId"];
    
	_videoDevice = device;
	[_videoDevice open:nil];
	
	if( !_videoDevice ) {
		NSLog( @"No video input device" );
		exit( 1 );
	}
	
	_videoInput = [[QTCaptureDeviceInput alloc] initWithDevice:_videoDevice];
	
	_captureSession = [[QTCaptureSession alloc] init];
	[_captureSession addInput:_videoInput error:nil];	
	[_captureSession startRunning];
	
	[captureView setCaptureSession:_captureSession];
	[captureView setVideoPreviewConnection:[[captureView availableVideoPreviewConnections] objectAtIndex:0]];
	captureView.delegate = self;
	captureView.canSelectRect = YES;
	
	
	// Setting a lower resolution for the CaptureOutput here, since otherwise QTCaptureView
	// pulls full-res frames from the camera, which is slow. This is just for cosmetics.
	
	// NOTE: for Logitech QuickCam Pro 9000 Webcam everythin >=1280 or > 720  puts camera into widescreen
	NSDictionary * pixelBufferAttr = [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithInt:1280], kCVPixelBufferWidthKey,
									  [NSNumber numberWithInt:720], kCVPixelBufferHeightKey, nil];
    // NOTE this doesn't have to be object at index 0, but for LifeCam it is: 
	[[[_captureSession outputs] objectAtIndex:0] setPixelBufferAttributes:pixelBufferAttr];
	
	
	
	
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
	
//	_cameraControl = [[UVCCameraControl alloc] initWithLocationID:locationID];
//	
//	[_cameraControl setAutoExposure:YES];
//	[_cameraControl setAutoWhiteBalance:YES];
//	[_cameraControl setAutoFocus:YES];
}


#pragma mark - properties

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(object == self.document && [@"activeCaptureDevice" isEqualToString:keyPath]) {
        [self connectToVideoDevice:self.document.activeCaptureDevice];
    } else
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


-(CHDocument *)document {
    return super.document;
}

-(void)setDocument:(CHDocument *)document {
    [self.document removeObserver:self forKeyPath:@"activeCaptureDevice"];
    [super setDocument:document];
    [self.document addObserver:self forKeyPath:@"activeCaptureDevice" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)captureDeviceChanged:(id)sender {
    self.document.activeCaptureDevice = [self.document.captureDevices objectAtIndex:[captureDevicesCombobox indexOfSelectedItem]];
}

@end
