//
//  RecentPhotoTVC.m
//  SPoT
//
//  Created by Daniela on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "RecentPhotoTVC.h"
#import "RecentPhoto.h"

@interface RecentPhotoTVC ()

@end

@implementation RecentPhotoTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setPhotos:[[RecentPhoto class]recentPhotoList]];
}


@end
