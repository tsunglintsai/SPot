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
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;
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
        [self setIsShowBusyIndicator:YES];
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        [self showBusyIndicator];
        dispatch_queue_t q = dispatch_queue_create("table view loading queue", NULL); dispatch_async(q, ^{
            //do something to get new data for this table view (which presumably takes time)
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                //update the table view's Model to the new data, reloadData if necessary // and let the user know the refresh is over (stop spinner)
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                if (image) {
                    self.scrollView.zoomScale = 1.0;
                    self.scrollView.contentSize = image.size;
                    self.imageView.image = image;
                    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                }
                [self hideBusyIndicator];
                [self makeImageFitInScrollView];
            });
        });
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


- (UIActivityIndicatorView*) activityIndicatorView{
    if(_activityIndicatorView == nil){
        _activityIndicatorView =
        [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityIndicatorView;
}


- (void)showBusyIndicator{
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    self.navigationItem.rightBarButtonItem =  barButton;
    [self.activityIndicatorView startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideBusyIndicator{
    self.navigationItem.rightBarButtonItem = nil;
    [self.activityIndicatorView stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
