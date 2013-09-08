//
//  LovedOne.h
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LovedOne : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSArray *pills;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *percentage;

- (id)initWithObjectId:(NSString *)objectId name:(NSString *)name phoneNumber:(NSString *)phoneNumber percentage:(NSString *)percentage;

@end
