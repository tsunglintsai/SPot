//
//  TagTVC.h
//  SPoT
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagTVC : UITableViewController
@property (strong,nonatomic) NSDictionary *tagList; // key is tag name, value is array of photo

@end
