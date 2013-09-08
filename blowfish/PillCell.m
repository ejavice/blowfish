//
//  PillCell.m
//  blowfish
//
//  Created by Jeff Grimes on 9/7/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import "PillCell.h"

@implementation PillCell

- (IBAction)dayPressed:(id)sender {
  UIButton *button = (UIButton *)sender;
  
  if (!button.selected) {
    [button setSelected:YES];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button.titleLabel setTextColor:[UIColor blackColor]];
  } else {
    [button setSelected:NO];
    [button setBackgroundColor:[UIColor grayColor]];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
  }
}

@end
