//
//  chaDocument.m
//  CamHolderApp
//
//  Created by Heiko Behrens on 31.01.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "CHDocument.h"
#import "CHWindowController.h"

@implementation CHDocument

@synthesize isAutoExposureActive, exposureTimeFactor, isAutoFocusActive, focusFactor, activeCaptureDevice, 
    normalizedCroppingRect, isMirroredHorizontally, isMirroredVertically, rotation;

- (id)init
{
    self = [super init];
    if (self) {
        isAutoExposureActive = YES;
        isAutoFocusActive = YES;
    }
    return self;
}

-(void)dealloc {
    [_cameraControl release];
    [super dealloc];
}

-(void)makeWindowControllers {
    CHWindowController *controller = [[[CHWindowController alloc] initWithWindowNibName:@"CHDocument"] autorelease];
    [self addWindowController:controller];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    /*
     Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    */
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    /*
    Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    */
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

#pragma mark - QT class helpers {

+(NSArray*)arrayWithAllSuitableDevices {
	static NSString* suitableModelUniqueID = @"UVC Camera VendorID_1118 ProductID_1906";
	NSArray *unfiltered = [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeVideo];
	NSMutableArray *result = [NSMutableArray array];
	for(QTCaptureDevice *d in unfiltered) {
		if([suitableModelUniqueID isEqualToString:[d modelUniqueID]])
			[result addObject: d];
	}
	return result;
}

+(NSArray*)cachedCaptureDevices {
    if(!CHCachedCaptureDevices) {
        CHCachedCaptureDevices = [[self arrayWithAllSuitableDevices] copy];
    }
    return CHCachedCaptureDevices;
}

#pragma mark - properties

+(NSSet *)keyPathsForValuesAffectingIsZoomed {
    return [NSSet setWithObjects:@"normalizedCroppingRect", nil];
}

-(BOOL)isZoomed {
    return !NSEqualRects(NSZeroRect, self.normalizedCroppingRect);
}

-(NSArray*)captureDevices {
    return [self.class cachedCaptureDevices];
}

-(void)setIsAutoExposureActive:(BOOL)isAutoExposureActive_ {
    isAutoExposureActive = isAutoExposureActive_;
    [_cameraControl setAutoExposure:isAutoExposureActive];
}

-(void)setExposureTimeFactor:(float)exposureTimeFactor_ {
    exposureTimeFactor = exposureTimeFactor_;
    [_cameraControl setExposure:exposureTimeFactor];
}

-(void)setIsAutoFocusActive:(BOOL)isAutoFocusActive_ {
    isAutoFocusActive = isAutoFocusActive_;
    [_cameraControl setAutoFocus:isAutoFocusActive];
}

-(void)setFocusFactor:(float)focusFactor_ {
    focusFactor = focusFactor_;
    [_cameraControl setAbsoluteFocus:focusFactor];
}

-(void)setActiveCaptureDevice:(QTCaptureDevice *)activeCaptureDevice_{
    [_cameraControl release];
    _cameraControl = nil;
    
    if(activeCaptureDevice_) {
        UInt32 locationID = 0;
        sscanf( [[activeCaptureDevice_ uniqueID] UTF8String], "0x%8x", (unsigned int*)&locationID );
        

        _cameraControl = [[UVCCameraControl alloc] initWithLocationID:locationID];
        
        [_cameraControl setAutoExposure:self.isAutoExposureActive];
        [_cameraControl setExposure:self.exposureTimeFactor];
        [_cameraControl setAutoFocus:self.isAutoFocusActive];
        [_cameraControl setAbsoluteFocus:self.focusFactor];
    }
    activeCaptureDevice = activeCaptureDevice_;
}

-(void)resetZoom {
    self.normalizedCroppingRect = NSZeroRect;
}

@end
