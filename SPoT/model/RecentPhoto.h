//
//  RecentPhoto.h
//  SPoT
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhoto : NSObject

+ (RecentPhoto*) sharedInstance;
- (NSArray*) recentPhotoList; // list of dictionaray
- (void) addPhoto : (id) photo; //

@end
