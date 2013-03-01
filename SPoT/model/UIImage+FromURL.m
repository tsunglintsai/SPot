//
//  UIImage+FromURL.m
//  SPoT
//
//  Created by Daniela on 2/28/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "UIImage+FromURL.h"
#import "ImageFetcher.h"

@implementation UIImage (FromURL)
+ (UIImage *)imageFromURL:(NSURL *)url{
    return [ImageFetcher getImageFromURL:url];
}
@end
