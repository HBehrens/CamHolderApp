//
//  CHDraggableWindow.h
//  CamHolderApp
//
//  Created by Heiko Behrens on 31.01.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface CHDraggableWindow : NSWindow {
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

@property (nonatomic, assign) BOOL isDraggable;

@end
