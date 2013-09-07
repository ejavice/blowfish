//
//  Pill.h
//  blowfish
//
//  Created by Jeff Grimes on 9/7/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  kPillTimeMorning,
  kPillTimeAfternoon,
  kPillTimeEvening
} PillTime;

@interface Pill : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) PillTime pillTime;

@end
