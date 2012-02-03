//
//  CHWindowController.h
//  CamHolderApp
//
//  Created by Heiko Behrens on 31.01.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CHDocument.h"
#import "CroppingQTCaptureView.h"
#import "CHDraggableWindow.h"

@interface CHWindowController : NSWindowController<NSWindowDelegate, CroppingQTCaptureViewDelegate> {
    QTCaptureSession *_captureSession;
    QTCaptureDevice *_videoDevice;
    QTCaptureDeviceInput *_videoInput;
    
    NSUInteger _originalWindowMask;
    NSRect _nonFullScreenFrame;
    NSRect _fullscreenFrame;
    BOOL _ignoreWindowDidResize;
    
    NSTimer *_updateTimer;
    
    IBOutlet NSComboBox *captureDevicesCombobox;
    IBOutlet NSSlider *exposureSlider;
    IBOutlet CroppingQTCaptureView *captureView;
    IBOutlet NSView* zoomRectView;
    IBOutlet NSView* inspectorView;
    
}

- (IBAction)captureDeviceChanged:(id)sender;

@property (nonatomic, assign) CHDocument* document;
@property (nonatomic, assign) CHDraggableWindow *window;

-(BOOL)showsInspector;
-(void)setShowsInspector:(BOOL)value;

@property (nonatomic, assign) BOOL isFullscreen;
@property (nonatomic, readonly) BOOL canBeFullscreen;
-(void)displayAsFullScreenInRect:(NSRect)frame;

-(void)setContentSize:(NSSize)size;

-(NSComparisonResult)horizontalCompare:(CHWindowController*)other;
-(NSComparisonResult)verticalCompare:(CHWindowController*)other;

-(NSPoint)convertPointToDocumentSpace:(NSPoint)viewSpacePoint;

@end

