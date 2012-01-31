//
//  CHDraggableWindow.m
//  CamHolderApp
//
//  Created by Heiko Behrens on 31.01.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "CHDraggableWindow.h"

@implementation CHDraggableWindow

@synthesize isDraggable;

// NOTE: taken from http://www.cocoadev.com/index.pl?BorderlessWindow

- (void)mouseDragged:(NSEvent *)theEvent
{
	if(!self.isDraggable)
		return;
	
	if (!isDragging)
	{
		initialLocation = [theEvent locationInWindow];
		initialLocationOnScreen = [self convertBaseToScreen:[theEvent locationInWindow]];
		
		initialFrame = [self frame];
		isDragging = YES;
		
		if (initialLocation.x > initialFrame.size.width - 20 && initialLocation.y < 20) {
			shouldDrag = NO;
		}
		else {
			//mouseDownType = PALMOUSEDRAGSHOULDMOVE;
			shouldDrag = YES;
		}
		
		screenFrame = [[NSScreen mainScreen] frame];
		windowFrame = [self frame];
		
		minY = windowFrame.origin.y+(windowFrame.size.height-288);
	}
	
	
	// 1. Is the Event a resize drag (test for bottom right-hand corner)?
	if (shouldDrag == FALSE)
	{
		// i. Remember the current downpoint
		NSPoint currentLocationOnScreen = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
		currentLocation = [theEvent locationInWindow];
		
		// ii. Adjust the frame size accordingly
		float heightDelta = (currentLocationOnScreen.y - initialLocationOnScreen.y);
		
		if ((initialFrame.size.height - heightDelta) < 289)
		{
			windowFrame.size.height = 288;
			//windowFrame.origin.y = initialLocation.y-(initialLocation.y - windowFrame.origin.y)+heightDelta;
			windowFrame.origin.y = minY;
		} else
		{
			windowFrame.size.height = (initialFrame.size.height - heightDelta);
			windowFrame.origin.y = (initialFrame.origin.y + heightDelta);
		}
		
		windowFrame.size.width = initialFrame.size.width + (currentLocation.x - initialLocation.x);
		if (windowFrame.size.width < 323)
		{
			windowFrame.size.width = 323;
		}
		
		// iii. Set
		[self setFrame:windowFrame display:YES animate:NO];
	}
    else
	{
		//grab the current global mouse location; we could just as easily get the mouse location 
		//in the same way as we do in -mouseDown:
		currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
		newOrigin.x = currentLocation.x - initialLocation.x;
		newOrigin.y = currentLocation.y - initialLocation.y;
		
		// Don't let window get dragged up under the menu bar
		if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) )
		{
			newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
		}
		
		//go ahead and move the window to the new location
		[self setFrameOrigin:newOrigin];
		
	}
}

- (void)mouseUp:(NSEvent *)theEvent
{
	isDragging = NO;
}

@end
