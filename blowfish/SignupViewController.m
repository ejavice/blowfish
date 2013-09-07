//
//  SignupViewController.m
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import <Parse/Parse.h>

#import "SignupViewController.h"
#import "SplashViewController.h"

static const float topToTitleLabelPadding = 30;
static const float titleLabelHeight = 50;
static const float titleLabelToUsernameFieldPadding = 10;
static const float usernameFieldToPasswordFieldPadding = 10;
static const float passwordFieldToEmailFieldPadding = 10;
static const float emailFieldToSignupButtonPadding = 30;

static const float entryFieldSidePadding = 44;
static const float entryFieldHeight = 40;

static const float signupButtonHeight = 40;
static const float signupButtonWidth = 100;

@interface SignupViewController () {
  UILabel *_titleLabel;
  UITextField *_usernameField;
  UITextField *_passwordField;
  UITextField *_emailField;
  UIButton *_signupButton;
}

@end

@implementation SignupViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topToTitleLabelPadding, self.view.bounds.size.width, titleLabelHeight)];
  _titleLabel.text = @"Sign up for Pillio";
  _titleLabel.textAlignment = NSTextAlignmentCenter;
  _titleLabel.font = [UIFont systemFontOfSize:22];
  [self.view addSubview:_titleLabel];
  
  _usernameField = [[UITextField alloc] initWithFrame:CGRectMake(entryFieldSidePadding, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + titleLabelToUsernameFieldPadding, self.view.bounds.size.width - 2 * entryFieldSidePadding, entryFieldHeight)];
  _usernameField.borderStyle = UITextBorderStyleLine;
  _usernameField.font = [UIFont systemFontOfSize:15];
  _usernameField.placeholder = @" username";
  _usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
  _usernameField.keyboardType = UIKeyboardTypeDefault;
  _usernameField.returnKeyType = UIReturnKeyNext;
  _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _usernameField.delegate = self;
  [self.view addSubview:_usernameField];
  
  _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(entryFieldSidePadding, _usernameField.frame.origin.y + _usernameField.frame.size.height + usernameFieldToPasswordFieldPadding, self.view.bounds.size.width - 2 * entryFieldSidePadding, entryFieldHeight)];
  _passwordField.secureTextEntry = YES;
  _passwordField.borderStyle = UITextBorderStyleLine;
  _passwordField.font = [UIFont systemFontOfSize:15];
  _passwordField.placeholder = @" password";
  _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
  _passwordField.keyboardType = UIKeyboardTypeDefault;
  _passwordField.returnKeyType = UIReturnKeyDone;
  _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _passwordField.delegate = self;
  [self.view addSubview:_passwordField];
  
  _emailField = [[UITextField alloc] initWithFrame:CGRectMake(entryFieldSidePadding, _passwordField.frame.origin.y + _passwordField.frame.size.height + passwordFieldToEmailFieldPadding, self.view.bounds.size.width - 2 * entryFieldSidePadding, entryFieldHeight)];
  _emailField.borderStyle = UITextBorderStyleLine;
  _emailField.font = [UIFont systemFontOfSize:15];
  _emailField.placeholder = @" email";
  _emailField.autocorrectionType = UITextAutocorrectionTypeNo;
  _emailField.keyboardType = UIKeyboardTypeEmailAddress;
  _emailField.returnKeyType = UIReturnKeyNext;
  _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _emailField.delegate = self;
  [self.view addSubview:_emailField];
  
  _signupButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - signupButtonWidth / 2, _emailField.frame.origin.y + _emailField.frame.size.height + emailFieldToSignupButtonPadding, signupButtonWidth, signupButtonHeight)];
  [_signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
  [_signupButton addTarget:self action:@selector(signupButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [_signupButton setBackgroundColor:[UIColor orangeColor]];
  [self.view addSubview:_signupButton];  
}

- (void)signupButtonPressed {
  PFUser *user = [PFUser user];
  user.username = _usernameField.text;
  user.password = _passwordField.text;
  user.email = _emailField.text;
  
  [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      [self loginUser];
    } else {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username already taken." delegate:self cancelButtonTitle:@"Back" otherButtonTitles: nil];
      [alertView show];
    }
  }];
}

- (void)loginUser {
  [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text
                                  block:^(PFUser *user, NSError *error) {
    if (user) {
      SplashViewController *splashViewController = [[SplashViewController alloc] init];
        [self.navigationController pushViewController:splashViewController animated:YES];
    } else {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong." delegate:self cancelButtonTitle:@"Back" otherButtonTitles: nil];
      [alertView show];
    }
  }];
}

@end
