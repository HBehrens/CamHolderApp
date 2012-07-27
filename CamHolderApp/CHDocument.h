//
//  chaDocument.h
//  CamHolderApp
//
//  Created by Heiko Behrens on 31.01.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import "UVCCameraControl.h"

extern NSArray* CHCachedCaptureDevices;

@interface CHDocument : NSDocument {
    UVCCameraControl *_cameraControl;
}

@property (nonatomic, assign) BOOL isAutoExposureActive;
@property (nonatomic, assign) float exposureTimeFactor;
@property (nonatomic, assign) BOOL isAutoFocusActive;
@property (nonatomic, assign) float focusFactor;

-(void)readCameraValuesIntoProperties;

@property (nonatomic, readonly) BOOL isZoomed;

@property (nonatomic, readonly) NSArray* captureDevices;
@property (nonatomic, retain) QTCaptureDevice* activeCaptureDevice;
-(void)tryToHaveActiveCaptureDevice;

@property (nonatomic, assign) NSRect normalizedCroppingRect;
@property (nonatomic, assign) BOOL isMirroredHorizontally;
@property (nonatomic, assign) BOOL isMirroredVertically;
@property (nonatomic, assign) float rotation;
@property (nonatomic, readonly) BOOL rotatedVertically;

-(void)resetZoom;

@property (nonatomic, assign) BOOL showsInspector;
@property (nonatomic, assign) NSSize contentSize;

-(IBAction)toggleInspector:(id)sender;

+(NSArray*)cachedCaptureDevices;

@end
