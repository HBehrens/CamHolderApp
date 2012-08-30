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

@synthesize activeSizeForSemiFullscreen;

static NSString* PREF_ActiveSemiFullscreenResolution = @"activeSemiFullscreenResolution";

-(void)showHelp:(id)sender {
    NSString *url = @"http://CamHolder.org/help";
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

-(void)activateSizeForSemiFullscreenWithIndex:(NSUInteger)index {
    NSString *s = [_semiFullscreenResolutions objectAtIndex:index];
    self.activeSizeForSemiFullscreen = NSSizeFromString(s);
}

-(void)prepareSemiFullscreen {
    // load from a file?
    _semiFullscreenResolutions = [[NSArray arrayWithObjects:@"{1024, 768}", @"{1280, 720}", @"{1920, 1080}", nil] retain];
    _semiFullscreenResolutionsMenuItems = [[NSMutableArray array] retain];
    NSString *selected = [[NSUserDefaults standardUserDefaults] stringForKey:PREF_ActiveSemiFullscreenResolution] ;
    
    NSMenu *menu = semiFullscreenMenu.menu;
    for(NSString *s in [_semiFullscreenResolutions reverseObjectEnumerator]) {
        NSSize size = NSSizeFromString(s);
        NSString *title = [NSString stringWithFormat:@"%dx%d", (int)size.width, (int)size.height];
        NSMenuItem *item = [[[NSMenuItem alloc] initWithTitle:title action:@selector(selectActiveSizeForSemiFullscreen:) keyEquivalent:@""] autorelease];
        item.indentationLevel = 2;
        item.state = [s isEqualToString:selected] ? 1 : 0;
        item.tag = [_semiFullscreenResolutions indexOfObject:s];
        [_semiFullscreenResolutionsMenuItems addObject:item];
        
        [menu insertItem:item atIndex:[menu indexOfItem:semiFullscreenMenu]+1];
    }
    
    [self activateSizeForSemiFullscreenWithIndex:[_semiFullscreenResolutions indexOfObject:selected]];
}

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"{1280, 720}" forKey:PREF_ActiveSemiFullscreenResolution];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    
    NSArray *allDevices = [CHDocument cachedCaptureDevices];
    if(allDevices.count <= 0) {
		NSAlert *alert = [NSAlert alertWithMessageText:@"Camera not found" 
										 defaultButton:nil alternateButton:nil otherButton:nil 
							 informativeTextWithFormat:@"Make sure to attach at least one camera of the model 'Microsoft LifeCam Studio' before running this application."];
		[alert runModal];
		[[NSApplication sharedApplication] terminate:self];
    }
    
    [self prepareSemiFullscreen];
}

-(void)dealloc {
    [_semiFullscreenResolutions release];
    [_semiFullscreenResolutionsMenuItems release];
    [super dealloc];
}

-(void)onScreen:(NSScreen*)screen withMaxSize:(NSSize)maxSize andControllers:(NSArray*)controllers setFullscreen:(BOOL)fullscreen {
    
    NSRect r = screen.frame;
    if(!NSEqualSizes(NSZeroSize, maxSize)) {
        r = NSOffsetRect(r, (r.size.width-maxSize.width) / 2, (r.size.height-maxSize.height) / 2);
        r.origin.x = MAX(r.origin.x, screen.frame.origin.x);
        r.origin.y = MAX(r.origin.y, screen.frame.origin.y);
        r.size.width = MIN(maxSize.width, screen.frame.size.width);
        r.size.height = MIN(maxSize.height, screen.frame.size.height);
    }
    
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

-(void)toggleFullscreenWithMaxSize:(NSSize)maxSize {
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
            [self onScreen: screen withMaxSize:maxSize andControllers:controllers setFullscreen:allToFullscreen];
    }
}
-(IBAction)toggleFullscreen:(id)sender {
    [self toggleFullscreenWithMaxSize:NSZeroSize];
}

-(IBAction)toggleSemiFullscreen:(id)sender {
    [self toggleFullscreenWithMaxSize:self.activeSizeForSemiFullscreen];
}

-(IBAction)selectActiveSizeForSemiFullscreen:(NSMenuItem*)sender {
    for(NSMenuItem *item in _semiFullscreenResolutionsMenuItems) {
        item.state = 0;
    }
    sender.state = 1;

    [self activateSizeForSemiFullscreenWithIndex:sender.tag];
    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromSize(self.activeSizeForSemiFullscreen) forKey:PREF_ActiveSemiFullscreenResolution];
}

-(void)tryToReduceRunningCaptureSessionsForApplicationThatWillBeHidden:(BOOL)applicationIsHidden {
    NSLog(@"trying to reduce running capture sessions");

    int stopped = 0;
    int running = 0;
    for(CHDocument *document in [[NSDocumentController sharedDocumentController] documents]) {
        for(CHWindowController *controller in document.windowControllers) {
            if([controller isKindOfClass:CHWindowController.class]) {
                if(!applicationIsHidden && !controller.window.isMiniaturized) {
                    [controller.captureSession startRunning];
                    running++;
                } else {
                    [controller.captureSession stopRunning];
                    stopped++;
                }
                    
            }
        }
    }
    NSLog(@"  %d running, %d stopped", running, stopped);
}

-(void)tryToReduceRunningCaptureSessions {
    [self tryToReduceRunningCaptureSessionsForApplicationThatWillBeHidden:NSApplication.sharedApplication.isHidden];
}

-(void)applicationDidHide:(NSNotification *)notification {
    [self tryToReduceRunningCaptureSessionsForApplicationThatWillBeHidden:YES];
}

-(void)applicationWillUnhide:(NSNotification *)notification {
    [self tryToReduceRunningCaptureSessionsForApplicationThatWillBeHidden:NO];
}

@end
