//
//  NSWindow+obscured.m
//  CamHolderApp
//
//  Created by Heiko Behrens on 31.08.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "NSWindow+obscured.h"
#import "CHGeometryUtils.h"

@implementation NSWindow (obscured)


-(BOOL)isObscured {
    NSSet* nonObscuredPieces = nil;
    
	CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenAboveWindow | kCGWindowListOptionIncludingWindow, self.windowNumber);
    
    for(NSDictionary *values in [((__bridge NSArray*)windowList) reverseObjectEnumerator]) {
		CGRect boundsOfWindowAbove;
		CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)[values objectForKey:(id)kCGWindowBounds], &boundsOfWindowAbove);
        
        // first element is window itself (since list is reversed)
        if([[values objectForKey:(id)kCGWindowNumber] isEqualToNumber:[NSNumber numberWithInt:self.windowNumber]]) {
            nonObscuredPieces = [NSSet setWithObject:[NSValue valueWithRect:NSRectFromCGRect(boundsOfWindowAbove)]];
            continue;
        }
        
        // hack: dock window covers main screen completely -> ignore
        NSString* windowOwnerName = [values objectForKey:(id)kCGWindowOwnerName];
        if([windowOwnerName isEqualToString:@"Dock"])
            continue;

        
        NSMutableSet *leftOvers = [NSMutableSet set];
        for(NSValue *piece in nonObscuredPieces) {
            [leftOvers unionSet:SubtractTwoRects(piece.rectValue, NSRectFromCGRect(boundsOfWindowAbove))];
        }
        nonObscuredPieces = leftOvers;
        
        if(nonObscuredPieces.count == 0)
            break;
    }
    CFRelease(windowList);
    
    return nonObscuredPieces.count <= 0;
}

@end
