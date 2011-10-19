//
//  CroppingQTCaptureView.m
//  CameraControl
//
//  Created by Heiko Behrens on 19.10.11.
//  Copyright 2011 BeamApp. All rights reserved.
//

#import "CroppingQTCaptureView.h"

@protocol CroppingQTCaptureViewDelegate

-(void)view:(QTCaptureView *)view didSelectRect:(NSRect)rect;
-(void)viewWillSelectRect:(QTCaptureView *)view;

@end


@implementation CroppingQTCaptureView

@synthesize canSelectRect;

-(void) drawRect:(NSRect)rect {
	[super drawRect:rect];
}

-(void) mouseDown:(NSEvent *)theEvent {
	if(self.canSelectRect) {
		ptMouseDown =  [self convertPoint:theEvent.locationInWindow fromView:nil];
		if([self.delegate respondsToSelector:@selector(viewWillSelectRect:)])
			[(id<CroppingQTCaptureViewDelegate>)self.delegate viewWillSelectRect:self];
	}
	[super mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent {
	if(self.canSelectRect) {
		NSPoint ptMouseUp = [self convertPoint:theEvent.locationInWindow fromView:nil];
		NSRect r = NSMakeRect(ptMouseDown.x, ptMouseDown.y, ptMouseUp.x-ptMouseDown.x, ptMouseUp.y-ptMouseDown.y);
		r.origin.x += r.size.width < 0 ? r.size.width : 0;
		r.origin.y += r.size.height< 0 ? r.size.height: 0;
		r.size.width = ABS(r.size.width);
		r.size.height = ABS(r.size.height);
		if([self.delegate respondsToSelector:@selector(view:didSelectRect:)]) 
			[(id<CroppingQTCaptureViewDelegate>)self.delegate view:self didSelectRect:r];
	}
	[super mouseUp:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent {
	if(self.canSelectRect)
		[self setNeedsDisplay:YES];
	[super mouseDragged:theEvent];
}
@end
