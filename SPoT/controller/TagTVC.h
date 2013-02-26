//
//  TagTVC.h
//  SPoT
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewTVC.h"

@interface TagTVC : MasterViewTVC
@property (strong,nonatomic) NSDictionary *tagList; // key is tag name, value is array of photo

@end
