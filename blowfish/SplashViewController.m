//
//  SplashViewController.m
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import "SplashViewController.h"

@implementation SplashViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
  label.text = @"loved ones here";
  [self.view addSubview:label];
}

@end
