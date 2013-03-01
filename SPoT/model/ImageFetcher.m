//
//  ImageFetcher.m
//  SPoT
//
//  Created by Daniela on 2/28/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "ImageFetcher.h"

#define PHOTO_CACHE_PLIST_FILENAME @"CachePropertyList"
#define MAX_CACHE_SIZE 1024*1024*5 // 5MB

@interface ImageFetcher()
@end
@implementation ImageFetcher

static ImageFetcher *imageFetcher;

-(UIImage*)getImageFromURL:(NSURL*)url{
    UIImage *result;
    imageFetcher = [[ImageFetcher alloc]init];
    NSURL *imageFileURL = [imageFetcher imageFileURLFromInternetURL:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
    if(imageData){ // if file not found download image from internet
        result = [UIImage imageWithData:imageData];
    }else{
        result = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
<<<<<<< HEAD
        [imageFetcher.plist insertObject:[url description] atIndex:0];
        [UIImageJPEGRepresentation(result, 1.0) writeToURL:imageFileURL atomically:YES];
        [imageFetcher cleanupCache];
    }else{ // move object to top
        [imageFetcher.plist removeObject:[url description]];
        [imageFetcher.plist insertObject:[url description] atIndex:0];
        result = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageFileURL]];
        
=======
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]]; // simulate latency
        [UIImageJPEGRepresentation(result, 1.0) writeToURL:imageFileURL atomically:YES];
>>>>>>> Use simpler approach in image fetch mode by using resource last access date in NSURL
    }
    [imageFetcher cleanupCache];
    return result;
}

-(void) cleanupCache{
    while([self totalCacheFileSizeInDisk]>MAX_CACHE_SIZE){
        [[NSFileManager defaultManager]removeItemAtURL:[self oldestImageFileURL] error:nil];
    }
}

-(NSURL*) oldestImageFileURL{
    NSMutableArray *fileURLs = [[NSMutableArray alloc]init];
    for(NSURL *fileUrl  in [[[NSFileManager alloc]init] contentsOfDirectoryAtURL:[self imageFolderUrl] includingPropertiesForKeys:@[NSURLContentAccessDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil]){
        [fileURLs addObject:fileUrl];
    }
    [fileURLs sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *dateForFile1,*dateForFile2;
        [obj1 getResourceValue:&dateForFile1 forKey:NSURLContentAccessDateKey error:nil];
        [obj2 getResourceValue:&dateForFile2 forKey:NSURLContentAccessDateKey error:nil];
        return [dateForFile2 compare:dateForFile1]; // sort file in access order, oldest one be back
    }];
    return [fileURLs lastObject];
}

-(float) totalCacheFileSizeInDisk{ // in bytes
    float result = 0;
    for(NSURL *fileUrl  in [[[NSFileManager alloc]init] contentsOfDirectoryAtURL:[self imageFolderUrl] includingPropertiesForKeys:@[NSURLNameKey,NSURLContentAccessDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil]){
        result+= [imageFetcher getFileSize:fileUrl];
    }
    return result;
}

-(NSURL*)imageFileURLFromInternetURL:(NSURL*)internetURL{
    return [[self imageFolderUrl] URLByAppendingPathComponent:[internetURL lastPathComponent]];
}

-(float) getFileSize: (NSURL*) fileUrl{ //  get image size in bytes
    // Get file attributes
    NSDictionary* attributeDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileUrl path] error:nil];
    // Get size attribute
    NSNumber* fileSizeObj = [attributeDict objectForKey:NSFileSize];
    return fileSizeObj.floatValue;
}

-(NSURL*)imageFolderUrl{
    NSFileManager* fileManager = [[NSFileManager alloc]init];// don't use defaultFilemanager, it's not thread safe
    NSURL *result = [[fileManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil]URLByAppendingPathComponent:@"image"];
    return result;
}

-(void) createImageFolder{
    NSFileManager* fileManager = [[NSFileManager alloc]init];// don't use defaultFilemanager, it's not thread safe
    [fileManager createDirectoryAtURL:[self imageFolderUrl] withIntermediateDirectories:YES attributes:nil error:nil];
}


@end
