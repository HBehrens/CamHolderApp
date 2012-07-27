//
//  CroppingQTCaptureView.h
//  CameraControl
//
//  Created by Heiko Behrens on 19.10.11.
//  Copyright 2011 BeamApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

@protocol CroppingQTCaptureViewDelegate

-(void)view:(QTCaptureView *)view didSelectRect:(NSRect)rect;
-(void)view:(QTCaptureView *)view mightSelectRectInViewCoordinates:(NSRect)rect;
-(void)viewWillSelectRect:(QTCaptureView *)view;

@end

@interface CroppingQTCaptureView : QTCaptureView {
	NSPoint ptMouseDown;
	NSRect currentSelection;
	NSRect currentSelectionInViewCoordinates;
	BOOL canSelectRect;
}

@property(nonatomic, assign) BOOL canSelectRect;
@property(nonatomic, assign) BOOL hiddenCursor;

@end
