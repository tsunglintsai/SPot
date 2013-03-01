//
//  SPoTTests.m
//  SPoTTests
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "SPoTTests.h"
#import "NetworkIndicatorHelper.h"

@implementation SPoTTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    [NetworkIndicatorHelper setNetworkActivityIndicatorVisible:YES];
    
}

@end
