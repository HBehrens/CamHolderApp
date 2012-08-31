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

// SubtractTwoRects by Graham Cox
// http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg04798.html

NSSet* SubtractTwoRects( const NSRect a, const NSRect b )
{
    // subtracts <b> from <a>, returning the pieces left over. If a and b don't intersect the result is correct // but maybe broken into pieces when it doesn't need to be, so the caller should test for intersection first.
    
    NSMutableSet* result = [NSMutableSet set];
    
    float rml, lmr, upb, lwt, mny, mxy;
    
    rml = MAX( NSMaxX( b ), NSMinX( a ));
    lmr = MIN( NSMinX( b ), NSMaxX( a ));
    upb = MAX( NSMaxY( b ), NSMinY( a ));
    lwt = MIN( NSMinY( b ), NSMaxY( a ));
    mny = MIN( NSMaxY( a ), NSMaxY( b ));
    mxy = MAX( NSMinY( a ), NSMinY( b ));
    
    NSRect          rr, rl, rt, rb;
    
    rr = NSMakeRect( rml, mxy, NSMaxX( a ) - rml, mny - mxy );
    rl = NSMakeRect( NSMinX( a ), mxy, lmr - NSMinX( a ), mny - mxy );
    rt = NSMakeRect( NSMinX( a ), upb, NSWidth( a ), NSMaxY( a ) - upb );
    rb = NSMakeRect( NSMinX( a ), NSMinY( a ), NSWidth( a ), lwt - NSMinY( a ));
    
    // add any non empty rects to the result
    
    if ( rr.size.width > 0 && rr.size.height > 0 )
        [result addObject:[NSValue valueWithRect:rr]];
    
    if ( rl.size.width > 0 && rl.size.height > 0 )
        [result addObject:[NSValue valueWithRect:rl]];
    
    if ( rt.size.width > 0 && rt.size.height > 0 )
        [result addObject:[NSValue valueWithRect:rt]];
    
    if ( rb.size.width > 0 && rb.size.height > 0 )
        [result addObject:[NSValue valueWithRect:rb]];
    
    return result;
}