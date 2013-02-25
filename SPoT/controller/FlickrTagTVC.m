//
//  FlickrTagTVC.m
//  SPoT
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "FlickrTagTVC.h"
#import "FlickrFetcher.h"

@interface FlickrTagTVC ()

@end

@implementation FlickrTagTVC

- (void) viewDidLoad{
    [super viewDidLoad];
    NSMutableDictionary *tagDictionaray = [[NSMutableDictionary alloc]init];
    for( id photoData in [FlickrFetcher stanfordPhotos]){
        if([photoData isKindOfClass:[NSDictionary class]]){
            NSDictionary *photoDataDictionary = photoData;
            NSArray *tags = [[photoDataDictionary valueForKeyPath:FLICKR_TAGS] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            for( NSString *tag in tags){
                if(![@[@"cs193pspot",@"portrait" , @"landscape" ] containsObject:tag]){ // remove those tags
                    [[[self class] photoListForTag:tag from:tagDictionaray] addObject:photoData]; // add photo to array of tag
                }
            }
        }
    }
    [self setTagList:[tagDictionaray copy]];
}


+ (NSMutableArray*)photoListForTag:(NSString*)tag from:(NSMutableDictionary*)tagPhotoMapping{
    NSMutableArray *result = [[tagPhotoMapping objectForKey:tag] mutableCopy];
    if(!result){
        result = [[NSMutableArray alloc]init];
    }
    // get photo sorted in Alpha order
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:FLICKR_PHOTO_TITLE ascending:YES selector:@selector(caseInsensitiveCompare:)];
    result = [[result sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
    [tagPhotoMapping setObject:result forKey:tag];
    return result;
}
@end
