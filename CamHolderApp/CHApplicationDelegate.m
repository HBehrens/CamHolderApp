//
//  CHApplicationDelegate.m
//  CamHolderApp
//
//  Created by Heiko Behrens on 31.01.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "CHApplicationDelegate.h"
#import "CHDocument.h"
#import "CHWindowController.h"

@implementation CHApplicationDelegate

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSArray *allDevices = [CHDocument cachedCaptureDevices];
    if(allDevices.count <= 0) {
		NSAlert *alert = [NSAlert alertWithMessageText:@"Camera not found" 
										 defaultButton:nil alternateButton:nil otherButton:nil 
							 informativeTextWithFormat:@"Make sure to attach at least one camera of the model 'Microsoft LifeCam Studio' before running this application."];
		[alert runModal];
		[[NSApplication sharedApplication] terminate:self];
    }
}

-(void)onScreen:(NSScreen*)screen andControllers:(NSArray*)controllers setFullscreen:(BOOL)fullscreen {
    NSRect r = screen.frame;
    BOOL alignHorizontally = [[controllers valueForKeyPath:@"@max.document.rotatedVertically"] boolValue];
    r.size.width  /= alignHorizontally ? controllers.count : 1;
    r.size.height /= alignHorizontally ? 1 : controllers.count;
    NSSize delta   = alignHorizontally ? NSMakeSize(r.size.width, 0) : NSMakeSize(0, r.size.height);
    
    SEL compareSelector = alignHorizontally ? @selector(horizontalCompare:) : @selector(verticalCompare:);
    controllers = [controllers sortedArrayUsingSelector:compareSelector];
    
    [NSAnimationContext beginGrouping];
    for(CHWindowController *controller in controllers) {
        if(fullscreen) {
            [controller displayAsFullScreenInRect:r];
            r = NSOffsetRect(r, delta.width, delta.height);
        } else {
            controller.isFullscreen = NO;
        }
    }
    [NSAnimationContext endGrouping];
}

-(IBAction)toggleFullscreen:(id)sender {
    // collect controllers per screen. This has to be more consize...
    NSMutableArray *controllersPerScreen = [NSMutableArray array];
    for(NSScreen *screen in NSScreen.screens) {
        [controllersPerScreen addObject:[NSMutableArray array]];
    }
    
    BOOL allToFullscreen = YES;
    for(CHDocument *document in [[NSDocumentController sharedDocumentController] documents]) {
        for(CHWindowController *controller in document.windowControllers) {
            if([controller isKindOfClass:CHWindowController.class] && controller.canBeFullscreen) {
                NSMutableArray *controllersAtThisScreen = [controllersPerScreen objectAtIndex:[NSScreen.screens indexOfObject:controller.window.screen]];
                [controllersAtThisScreen addObject:controller];
                allToFullscreen = allToFullscreen && !controller.isFullscreen;
            }
        }
    }
    
    // actually apply fullscreen operation per screen
    for(NSScreen *screen in NSScreen.screens) {
        NSArray *controllers = [controllersPerScreen objectAtIndex:[NSScreen.screens indexOfObject:screen]];
        if(controllers.count > 0)
            [self onScreen: screen andControllers:controllers setFullscreen:allToFullscreen];
    }
}

@end
