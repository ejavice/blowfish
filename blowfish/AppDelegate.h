//
//  AppDelegate.h
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *viewController;

@end
