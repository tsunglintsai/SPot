//
//  MasterViewTVC.m
//  SPoT
//
//  Created by Henry on 2/25/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "MasterViewTVC.h"
#import "NetworkIndicatorHelper.h"

@interface MasterViewTVC ()<UITableViewDelegate>
@property(strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MasterViewTVC


#pragma mark - UISplitViewControllerDelegate

- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void) awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"Photos";
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if ([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if ([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:nil];
}

# pragma mark - Split view: transfer button

- (id)splitViewDetailWithBarButtonItem
{
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if (![detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)] ||
        ![detailViewController respondsToSelector:@selector(splitViewBarButtonItem)]) detailViewController = nil;
    return detailViewController;
}

- (void)transferSplitViewBarButtonItemToViewController:(id)destinationViewController
{
    UIBarButtonItem *splitViewBarButtonItem = [[self splitViewDetailWithBarButtonItem] performSelector:@selector(splitViewBarButtonItem)];
    [[self splitViewDetailWithBarButtonItem] performSelector:@selector(setSplitViewBarButtonItem:) withObject:nil];
    if (splitViewBarButtonItem)
        [destinationViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:splitViewBarButtonItem];
}

# pragma mark - UITableView Delegate

- (void) refresh {
    [self.refreshControl beginRefreshing];
    [self showBusyIndicator];
    dispatch_queue_t q = dispatch_queue_create("table view loading queue", NULL); dispatch_async(q, ^{
        //do something to get new data for this table view (which presumably takes time)
        id modelData = [self fetchModelData];
        dispatch_async(dispatch_get_main_queue(), ^{
            //update the table view's Model to the new data, reloadData if necessary // and let the user know the refresh is over (stop spinner)
            [self updateTableViewModel:modelData];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            [self hideBusyIndicator];
       });
    });
}

- (id) fetchModelData{
    // abstract
    return nil;
}

- (void) updateTableViewModel : (id) modelData{
    // abstract
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
    [NetworkIndicatorHelper setNetworkActivityIndicatorVisible:YES];
}

- (void)hideBusyIndicator{
    [NetworkIndicatorHelper setNetworkActivityIndicatorVisible:NO];
}
@end
