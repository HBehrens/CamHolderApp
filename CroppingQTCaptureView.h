//
//  CroppingQTCaptureView.h
//  CameraControl
//
//  Created by Heiko Behrens on 19.10.11.
//  Copyright 2011 BeamApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

@interface CroppingQTCaptureView : QTCaptureView {
	NSPoint ptMouseDown;
	NSRect currentSelection;
	BOOL canSelectRect;
}

@property(nonatomic, assign) BOOL canSelectRect;

@end
