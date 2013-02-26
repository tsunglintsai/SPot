//
//  RecentPhoto.m
//  SPoT
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "RecentPhoto.h"

#define MAX_RECENT_PHOTO_COUNT 5
#define RECENT_PHOTO_KEY_IN_USER_DEFAULT @"RECENT_PHOTO"

@interface RecentPhoto()

@end

@implementation RecentPhoto


+ (NSArray*) recentPhotoList{
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSArray *result = [[NSUserDefaults standardUserDefaults] valueForKey:RECENT_PHOTO_KEY_IN_USER_DEFAULT];
    if(!result){
        result =  [[NSArray alloc]init];
    }
    return result;
}

+ (void) addPhoto : (id) photo{
    NSMutableArray *recenPhotoList = [[[self class]recentPhotoList]mutableCopy];
    if(![recenPhotoList containsObject:photo]){ // don't put duplicated picture
        if([recenPhotoList count] >= MAX_RECENT_PHOTO_COUNT){ // limit number of photo in store
            [recenPhotoList removeObject:[recenPhotoList lastObject]];
        }
    }else{ // if already exist put photo to top of list
        [recenPhotoList removeObject:photo];
    }
    [recenPhotoList insertObject:photo atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:[recenPhotoList copy] forKey:RECENT_PHOTO_KEY_IN_USER_DEFAULT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
