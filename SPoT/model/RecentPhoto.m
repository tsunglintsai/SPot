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
@property (nonatomic, strong) NSMutableArray *photoList;
@property (strong,nonatomic) NSUserDefaults *userDefault;

@end

@implementation RecentPhoto

static RecentPhoto* _sharedInstance = nil;

+ (RecentPhoto*) sharedInstance{ // singleton instance
    @synchronized([RecentPhoto class]){
        if (!_sharedInstance){
            _sharedInstance = [[self alloc] init];
        }
        return _sharedInstance;
    }
    return nil;
    
}

- (NSUserDefaults*)userDefault{
    if(!_userDefault){
        _userDefault = [[NSUserDefaults alloc]init];
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return _userDefault;
}

- (NSMutableArray*) photoList{
    if(!_photoList){
        [self.userDefault synchronize];
        _photoList = [[self.userDefault valueForKeyPath:RECENT_PHOTO_KEY_IN_USER_DEFAULT] mutableCopy];// user default always returns immutable object so make a mutable copy
    }
    if(!_photoList){
        _photoList = [[NSMutableArray alloc]init];
    }
    return _photoList;
}

- (NSArray*) recentPhotoList{
    return [self.photoList copy];
}

- (void) addPhoto : (id) photo{
    if(![self.photoList containsObject:photo]){ // don't put duplicated picture
        if([self.photoList count] >= MAX_RECENT_PHOTO_COUNT){ // limit number of photo in store
            [self.photoList removeObject:[self.photoList lastObject]];
        }
    }else{ // if already exist put photo to top of list
        [self.photoList removeObject:photo];
    }
    [self.photoList insertObject:photo atIndex:0];
    [self.userDefault setObject:[self.photoList copy] forKey:RECENT_PHOTO_KEY_IN_USER_DEFAULT];
    [self.userDefault synchronize];
}

@end
