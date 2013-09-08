//
//  Pill.h
//  blowfish
//
//  Created by Jeff Grimes on 9/7/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pill : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSString *days;
@property (nonatomic, retain) NSString *pillTime;
@property (nonatomic, retain) NSString *smsOrPhone;

- (id)initWithObjectId:(NSString *)objectId name:(NSString *)name days:(NSString *)days pillTime:(NSString *)pillTime smsOrPhone:(NSString *)smsOrPhone;

@end
