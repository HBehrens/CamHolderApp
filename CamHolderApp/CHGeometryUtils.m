//
//  CHGeometryUtils.m
//  CamHolderApp
//
//  Created by Heiko Behrens on 03.02.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "CHGeometryUtils.h"

NSRect NSCanonicalRect(NSRect r) {
	r.origin.x += r.size.width < 0 ? r.size.width : 0;
	r.origin.y += r.size.height< 0 ? r.size.height: 0;
	r.size.width = ABS(r.size.width);
	r.size.height = ABS(r.size.height);
    return r;
}
NSRect NSRectFromPoints(NSPoint p1, NSPoint p2) {
    return NSCanonicalRect(NSMakeRect(p1.x, p1.y, p2.x-p1.x, p2.y-p1.y));
}