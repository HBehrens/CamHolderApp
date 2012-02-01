//
//  CHApplicationDelegate.m
//  CamHolderApp
//
//  Created by Heiko Behrens on 31.01.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "CHApplicationDelegate.h"
#import "CHDocument.h"

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

@end
