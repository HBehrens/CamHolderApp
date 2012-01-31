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

@interface CHWindowController : NSWindowController<NSWindowDelegate> {
    QTCaptureSession *_captureSession;
    QTCaptureDevice *_videoDevice;
    QTCaptureDeviceInput *_videoInput;
    
    IBOutlet NSComboBox *captureDevicesCombobox;
    IBOutlet CroppingQTCaptureView *captureView;
}

- (IBAction)captureDeviceChanged:(id)sender;

@property (nonatomic, assign) CHDocument* document;


@end
