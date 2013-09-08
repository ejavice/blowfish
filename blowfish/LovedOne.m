//
//  LovedOne.m
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import "LovedOne.h"

@implementation LovedOne

- (id)initWithObjectId:(NSString *)objectId name:(NSString *)name phoneNumber:(NSString *)phoneNumber {
  if (self = [super init]) {
    self.objectId = objectId;
    self.name = name;
    self.phoneNumber = phoneNumber;
  }
  return self;
}

@end
