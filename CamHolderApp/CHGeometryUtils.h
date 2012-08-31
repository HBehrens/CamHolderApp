//
//  CHGeometryUtils.h
//  CamHolderApp
//
//  Created by Heiko Behrens on 03.02.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import <Foundation/Foundation.h>

NSRect NSCanonicalRect(NSRect rect);
NSRect NSRectFromPoints(NSPoint p1, NSPoint p2);
NSSet *SubtractTwoRects( const NSRect a, const NSRect b );

