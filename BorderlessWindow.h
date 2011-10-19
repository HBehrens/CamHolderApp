//
//  BorderlessWindow.h
//  CameraControl
//
//  Created by Heiko Behrens on 19.10.11.
//  Copyright 2011 BeamApp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BorderlessWindow : NSWindow {
	BOOL shouldDrag;
	BOOL isDragging;
	NSPoint initialLocation;
	NSPoint initialLocationOnScreen;
	NSRect initialFrame;
	NSPoint currentLocation;
	NSPoint newOrigin;
	NSRect screenFrame;
	NSRect windowFrame;
	float minY;
}

@end
