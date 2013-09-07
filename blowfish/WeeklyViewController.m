//
//  WeeklyViewController.m
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import "WeeklyViewController.h"
#import "LovedOne.h"

@interface WeeklyViewController () {
  LovedOne *_lovedOne;
}

@end

@implementation WeeklyViewController

- (id)initWithLovedOne:(LovedOne *)lovedOne {
  if (self = [super init]) {
    _lovedOne = lovedOne;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 200, 50)];
  label.text = _lovedOne.name;
  
  [self.view addSubview:label];
}

@end
