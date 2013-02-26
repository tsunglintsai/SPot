//
//  ImageViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem; 
@end

@implementation ImageViewController
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
// resets the image whenever the URL changes

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

// fetches the data from the URL
// turns it into an image
// adjusts the scroll view's content size to fit the image
// sets the image as the image view's image
- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
}

-(void)makeImageFitInScrollView{
    if(self.imageView.image){
        // make image fill whole screen
        self.scrollView.zoomScale = 1.0;
        self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
        float xScale = self.scrollView.bounds.size.width/self.imageView.image.size.width;
        float yScale = self.scrollView.bounds.size.height/self.imageView.image.size.height;
        CGRect zoomToRect;
        float xOffset = 0;
        float yOffset = 0;
        if(yScale > xScale){
            xOffset = (self.imageView.bounds.size.width * yScale - self.scrollView.bounds.size.width )/2;
            zoomToRect = CGRectMake(0, 0, 0, self.imageView.image.size.height);
        }else{
            yOffset = (self.imageView.bounds.size.height * xScale - self.scrollView.bounds.size.height )/2;
            zoomToRect = CGRectMake(0, 0, self.imageView.image.size.width, 0);
        }
        [self.scrollView zoomToRect:zoomToRect animated:false];
        self.scrollView.contentOffset = CGPointMake(xOffset , yOffset );
    }
}

// lazy instantiation

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

// returns the view which will be zoomed when the user pinches
// in this case, it is the image view, obviously
// (there are no other subviews of the scroll view in its content area)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
    self.titleBarButtonItem.title = self.title;
    self.splitViewBarButtonItem = self.splitViewBarButtonItem;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self makeImageFitInScrollView];
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

@end
