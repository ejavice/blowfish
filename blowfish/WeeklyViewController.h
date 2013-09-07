//
//  WeeklyViewController.h
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LovedOne.h"
#import "Pill.h"

@interface WeeklyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *pills;

- (id)initWithLovedOne:(LovedOne *)lovedOne;

@end
