//
//  ZoomRectView.m
//  CameraControl
//
//  Created by Heiko Behrens on 17.01.12.
//  Copyright 2012 BeamApp. All rights reserved.
//

#import "ZoomRectView.h"


@implementation ZoomRectView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.5] set];
	NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
    NSRectFill(rect);
	[[NSColor whiteColor] set];
	NSFrameRect(rect);
}

@end
