//
//  CHWindowControllerTests.m
//  CamHolderApp
//
//  Created by Heiko Behrens on 03.02.12.
//  Copyright (c) 2012 BeamApp. All rights reserved.
//

#import "CHWindowControllerTests.h"

@implementation CHWindowControllerTests
@synthesize controller, document;

- (void)setUp
{
    [super setUp];
    
    self.controller = [[CHWindowController new] autorelease];
    self.document = [[CHDocument new] autorelease];
    self.controller.document = self.document;
}

- (void)tearDown
{
    self.controller = nil;
    self.document = nil;
    
    [super tearDown];
}

- (void)testZoomingDoesNotResetsRotationOrFlipping
{
    document.rotation = 90;
    document.isMirroredHorizontally = YES;
    document.isMirroredVertically = YES;
    [controller viewWillSelectRect:nil];
    STAssertFalse(document.rotation == 0, @"resets rotation");
    STAssertFalse(document.isMirroredHorizontally == NO, @"resets horizontal flipping");
    STAssertFalse(document.isMirroredVertically == NO, @"resets vertical flipping");
}

#define STAssertEqualPoints(expected, actual, description, ...) \
do { \
BOOL _evaluatedExpression = NSEqualPoints(expected, actual);\
if (!_evaluatedExpression) {\
NSString *_expression = [NSString stringWithFormat: @"%@ == %@", NSStringFromPoint(expected), NSStringFromPoint(actual)];\
[self failWithException:([NSException failureInCondition:_expression \
isTrue:NO \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:@"%@", STComposeString(description, ##__VA_ARGS__)])]; \
} \
} while (0)

- (void)testSimpleZoom
{
    [controller viewWillSelectRect:nil];

    [controller view:nil didSelectRect:NSMakeRect(0, 0, 0.5, 0.5)];
    STAssertTrue(NSEqualRects(NSMakeRect(0,0, 0.5, 0.5), document.normalizedCroppingRect), @"first zoom");
    
    [controller view:nil didSelectRect:NSMakeRect(0.5, 0.5, 1, 1)];
    STAssertTrue(NSEqualRects(NSMakeRect(0.25,0.25, 0.5, 0.5), document.normalizedCroppingRect), @"second zoom");
}

- (void)testRotatedZoom
{
    [controller viewWillSelectRect:nil];
    document.rotation = 90;
    [controller view:nil didSelectRect:NSMakeRect(0, 0, 0.5, 0.5)];
    STAssertTrue(NSEqualRects(NSMakeRect(0,0.5, 0.5, 0.5), document.normalizedCroppingRect), @"rotated zoom");
}

- (void)testUnrotatedCoordinateTransformation {
    NSPoint p = NSMakePoint(0.1, 0.2);
    STAssertEqualPoints(NSMakePoint(0.1, 0.2), [controller convertPointToDocumentSpace:p], @"no transformation");
    
    document.normalizedCroppingRect = NSMakeRect(0, 0, 0.25, 0.5);
    STAssertEqualPoints(NSMakePoint(0.025, 0.1), [controller convertPointToDocumentSpace:p], @"zero-based zoom");
    
    document.normalizedCroppingRect = NSMakeRect(0.1, 0.2, 1, 1);
    STAssertEqualPoints(NSMakePoint(0.2, 0.4), [controller convertPointToDocumentSpace:p], @"different offset");
}

- (void)testRotatedCoordinateTransformation {
    float a = 1.0/8;
    float b = 1.0/16;
    NSPoint p = NSMakePoint(a, b);
    document.rotation = 90;
    STAssertEqualPoints(NSMakePoint(b, 1-a), [controller convertPointToDocumentSpace:p], @"90 degrees");
    
    document.rotation = 180;
    STAssertEqualPoints(NSMakePoint(1-a, 1-b), [controller convertPointToDocumentSpace:p], @"180 degrees");
    
    document.rotation = 270;
    STAssertEqualPoints(NSMakePoint(1-b, a), [controller convertPointToDocumentSpace:p], @"180 degrees");
}

- (void)testRotationAngleWillBeNormalized {
    document.rotation = 0;
    STAssertEquals(0.0f, document.rotation, @"0");
    document.rotation = -90;
    STAssertEquals(270.0f, document.rotation, @"-90");
    document.rotation = -180;
    STAssertEquals(180.0f, document.rotation, @"-180");
    document.rotation = -270;
    STAssertEquals(90.0f, document.rotation, @"-270");
    document.rotation = -0;
    STAssertEquals(0.0f, document.rotation, @"-0");
    
}


@end
