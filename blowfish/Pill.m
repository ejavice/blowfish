//
//  Pill.m
//  blowfish
//
//  Created by Jeff Grimes on 9/7/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import "Pill.h"

@implementation Pill

- (id)initWithObjectId:(NSString *)objectId name:(NSString *)name days:(NSString *)days pillTime:(NSString *)pillTime smsOrPhone:(NSString *)smsOrPhone {
  if (self = [super init]) {
    self.objectId = objectId;
    self.name = name;
    self.days = days;
    self.pillTime = pillTime;
    self.smsOrPhone = smsOrPhone;
  }
  return self;
}

@end
