//
//  CHWindowControllerTests.h
//  CamHolderApp
//
//  Created by Heiko Behrens on 03.02.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.

#import <SenTestingKit/SenTestingKit.h>
#import "CHWindowController.h"

@interface CHWindowControllerTests : SenTestCase

@property (nonatomic, retain) CHWindowController* controller;
@property (nonatomic, retain) CHDocument* document;

@end
