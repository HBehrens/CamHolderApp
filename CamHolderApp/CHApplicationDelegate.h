//
//  CHApplicationDelegate.h
//  CamHolderApp
//
//  Created by Heiko Behrens on 31.01.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHApplicationDelegate : NSObject<NSApplicationDelegate> {
    IBOutlet NSMenuItem* semiFullscreenMenu;
    NSArray *_semiFullscreenResolutions;
    NSMutableArray *_semiFullscreenResolutionsMenuItems;
}

@property (nonatomic, assign) NSSize activeSizeForSemiFullscreen;

-(IBAction)showHelp:(id)sender;
-(IBAction)toggleFullscreen:(id)sender;
-(IBAction)toggleSemiFullscreen:(id)sender;
-(IBAction)selectActiveSizeForSemiFullscreen:(id)sender;

-(void)tryToReduceRunningCaptureSessions;

@end
