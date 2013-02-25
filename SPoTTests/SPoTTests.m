//
//  SPoTTests.m
//  SPoTTests
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "SPoTTests.h"
#import "RecentPhoto.h"

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
    NSLog(@"recent photo:%@",[[RecentPhoto sharedInstance]recentPhotoList]);
    NSLog(@"recent photo count:%i",[[[RecentPhoto sharedInstance]recentPhotoList]count]);
    for( id photo in [[RecentPhoto sharedInstance]recentPhotoList]){
        NSLog(@"photo:%@",photo);
    }
    
    NSMutableDictionary *fakePhotoData = [[NSMutableDictionary alloc]init];
    [fakePhotoData setObject:@"http://images.apple.com/home/images/promo_ipad6.png" forKey:@"url"];
    
    [[RecentPhoto sharedInstance]addPhoto:fakePhotoData];
    
    NSLog(@"recent photo count:%i",[[[RecentPhoto sharedInstance]recentPhotoList]count]);
    for( id photo in [[RecentPhoto sharedInstance]recentPhotoList]){
        NSLog(@"photo:%@",photo);
    }
}

@end
