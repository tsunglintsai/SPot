//
//  MasterViewTVC.h
//  SPoT
//
//  Created by Henry on 2/25/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewTVC : UITableViewController<UISplitViewControllerDelegate>
- (void)transferSplitViewBarButtonItemToViewController:(id)destinationViewController;
- (id) fetchModelData;
- (void) updateTableViewModel : (id) modelData;
- (void) refresh;

@end
