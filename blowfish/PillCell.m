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
  } else {
    [button setSelected:NO];
    [button setBackgroundColor:[UIColor lightGrayColor]];
  }
}

- (IBAction)pillTimePressed:(id)sender {
  UIButton *button = (UIButton *)sender;
  NSString *time = button.titleLabel.text;
  if ([time isEqualToString:@"Morning"]) {
    self.morningButton.backgroundColor = [UIColor redColor];
    self.afternoonButton.backgroundColor = [UIColor lightGrayColor];
    self.eveningButton.backgroundColor = [UIColor lightGrayColor];
    
    self.morningButton.selected = YES;
    self.afternoonButton.selected = NO;
    self.eveningButton.selected = NO;
  } else if ([time isEqualToString:@"Afternoon"]) {
    self.morningButton.backgroundColor = [UIColor lightGrayColor];
    self.afternoonButton.backgroundColor = [UIColor redColor];
    self.eveningButton.backgroundColor = [UIColor lightGrayColor];
    
    self.morningButton.selected = NO;
    self.afternoonButton.selected = YES;
    self.eveningButton.selected = NO;
  } else {
    self.morningButton.backgroundColor = [UIColor lightGrayColor];
    self.afternoonButton.backgroundColor = [UIColor lightGrayColor];
    self.eveningButton.backgroundColor = [UIColor redColor];
    
    self.morningButton.selected = NO;
    self.afternoonButton.selected = NO;
    self.eveningButton.selected = YES;
  }
}

- (IBAction)landlineButtonPressed:(id)sender {
  UIButton *button = (UIButton *)sender;
  if (button.selected) {
    [button setImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    button.selected = NO;
  } else {
    [button setImage:[UIImage imageNamed:@"landline.png"] forState:UIControlStateNormal];
    button.selected = YES;
  }
}

@end
