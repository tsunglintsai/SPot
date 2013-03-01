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
@property (strong,nonatomic) NSMutableArray *plist; // use property list to persist mapping url-photofile mapping, array of nsarray{url,filename}]
@end
@implementation ImageFetcher

static ImageFetcher *imageFetcher;

+(UIImage*)getImageFromURL:(NSURL*)url{
    UIImage *result;
    if(!imageFetcher){
        imageFetcher = [[ImageFetcher alloc]init];
        [imageFetcher createImageFolder];
    }
    NSURL *imageFileURL = [imageFetcher imageFileURLFromInternetURL:url];
    if(![imageFetcher.plist containsObject:[url description]]){
        result = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [imageFetcher.plist insertObject:[url description] atIndex:0];
        [UIImageJPEGRepresentation(result, 1.0) writeToURL:imageFileURL atomically:YES];
        [imageFetcher cleanupCache];
    }else{ // move object to top
        [imageFetcher.plist removeObject:[url description]];
        [imageFetcher.plist insertObject:[url description] atIndex:0];
        result = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageFileURL]];
        
    }
    [imageFetcher savePropertyList];
    return result;
}

-(void) cleanupCache{
    while([self totalCacheFileSizeInDisk]>MAX_CACHE_SIZE && [[self plist]count]!=0){
        NSURL *lastImageURL = [NSURL URLWithString:[[self plist]lastObject]];
        NSURL *fileURL = [self imageFileURLFromInternetURL:lastImageURL];
        [[NSFileManager defaultManager]removeItemAtURL:fileURL error:nil];
        [[self plist]removeLastObject];
    }
}


-(float) totalCacheFileSizeInDisk{ // in bytes
    float result = 0;
    for(id data in imageFetcher.plist){
        if([data isKindOfClass:[NSString class]]){
            NSURL *imageURL = [NSURL URLWithString:data];
            result+= [imageFetcher getFileSize:[self imageFileURLFromInternetURL:imageURL]];
        }
    }
    return result;
}

-(NSURL*)imageFileURLFromInternetURL:(NSURL*)internetURL{
    return [[[self imageFolderUrl] URLByAppendingPathComponent:[internetURL lastPathComponent]]URLByAppendingPathExtension:@"jpg"];
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

-(NSMutableArray*)plist{
    if(!_plist){
        // if plist file not there, create a new one.
        _plist = [[NSMutableArray alloc] initWithContentsOfURL:[self propertyListFileUrl]];
        if(!_plist){ // file doesn't exit then create new dictionaray
            _plist = [[NSMutableArray alloc]init];
        }
    }
    return _plist;
}

-(NSURL*) propertyListFileUrl{
    NSFileManager* fileManager = [[NSFileManager alloc]init];// don't use defaultFilemanager, it's not thread safe
    NSURL *documentDirectory = [fileManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL *propertyListFileUrl = [[documentDirectory URLByAppendingPathComponent:PHOTO_CACHE_PLIST_FILENAME] URLByAppendingPathExtension:@"plist"];
    return propertyListFileUrl;
}

-(void) savePropertyList{    
    [self.plist writeToURL:[self propertyListFileUrl] atomically:YES];
}
         
@end
