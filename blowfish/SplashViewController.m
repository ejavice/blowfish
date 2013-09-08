//
//  SplashViewController.m
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import <Parse/Parse.h>

#import "SplashViewController.h"
#import "WeeklyViewController.h"
#import "LovedOne.h"
#import "LovedOneCell.h"

static const float topBarHeight = 50;
static const float topBarButtonSidePadding = 11;
static const float topBarButtonSize = 26;

@interface SplashViewController () {
  UITableView *_tableView;
  UIButton *_plusButton;
  
  UITextField *_nameField;
  UITextField *_phoneField;
}

@end

@implementation SplashViewController

- (id)init {
  if (self = [super init]) {
    self.lovedOnes = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"knitting.png"]]];

  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - topBarHeight) style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.separatorColor = [UIColor clearColor];
  _tableView.backgroundColor = [UIColor clearColor];
  [_tableView registerNib:[UINib nibWithNibName:@"LovedOneCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LovedOneCellReuseID"];
  [self.view addSubview:_tableView];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, topBarHeight)];
  titleLabel.text = @"My Loved Ones";
  titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.backgroundColor = [UIColor orangeColor];
  titleLabel.textColor = [UIColor whiteColor];
  [self.view addSubview:titleLabel];
  
  _plusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - topBarButtonSidePadding - topBarButtonSize, (topBarHeight - topBarButtonSize) / 2, topBarButtonSize, topBarButtonSize)];
  [_plusButton setImage:[UIImage imageNamed:@"plus-icon-white.png"] forState:UIControlStateNormal];
  [_plusButton addTarget:self action:@selector(plusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_plusButton];
  
  [self reloadTableViewWithNewLovedOne:NO];
}

- (void)reloadTableViewWithNewLovedOne:(BOOL)newLovedOne {
  PFQuery *query = [PFQuery queryWithClassName:@"Loved_Ones"];
  [query whereKey:@"associatedUser" equalTo:[PFUser currentUser].objectId];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      for (PFObject *object in objects) {
        NSString *objectId = object.objectId;
        NSString *name = [object objectForKey:@"name"];
        NSString *phoneNumber = [object objectForKey:@"phoneNumber"];
        if (![self lovedOneAlreadyExists:objectId]) {
          LovedOne *lovedOne = [[LovedOne alloc] initWithObjectId:objectId name:name phoneNumber:phoneNumber];
          [self.lovedOnes addObject:lovedOne];
        }
      }
      [_tableView reloadData];
      if (newLovedOne) {
        LovedOne *newLovedOne = [self.lovedOnes objectAtIndex:self.lovedOnes.count - 1];
        WeeklyViewController *weeklyViewController = [[WeeklyViewController alloc] initWithLovedOne:newLovedOne];
        [self.navigationController pushViewController:weeklyViewController animated:YES];
        NSIndexPath *path = [NSIndexPath indexPathWithIndex:self.lovedOnes.count - 1];
        [_tableView deselectRowAtIndexPath:path animated:YES];
      }
    } else {
      NSLog(@"Error: %@, %@", error, [error userInfo]);
    }
  }];
}

- (BOOL)lovedOneAlreadyExists:(NSString *)objectId {
  for (LovedOne *lovedOne in self.lovedOnes) {
    if ([lovedOne.objectId isEqualToString:objectId]) {
      return YES;
    }
  }
  return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.lovedOnes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"LovedOneCellReuseID";
  
  LovedOneCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[LovedOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  LovedOne *lovedOne = [self.lovedOnes objectAtIndex:indexPath.row];
  cell.nameLabel.text = lovedOne.name;
  cell.phoneLabel.text = [self formatPhoneNumber:lovedOne.phoneNumber];
  cell.selectionStyle = UITableViewCellSelectionStyleGray;
  return cell;
}

- (NSString *)formatPhoneNumber:(NSString *)phoneNumber {
  phoneNumber = [phoneNumber substringFromIndex:1];
  NSString *areaCode = [phoneNumber substringWithRange:NSMakeRange(0, 3)];
  NSString *firstThree = [phoneNumber substringWithRange:NSMakeRange(3, 3)];
  NSString *lastFour = [phoneNumber substringFromIndex:6];
  return [NSString stringWithFormat:@"(%@) %@-%@", areaCode, firstThree, lastFour];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LovedOne *lovedOne = [self.lovedOnes objectAtIndex:indexPath.row];
  WeeklyViewController *weeklyViewController = [[WeeklyViewController alloc] initWithLovedOne:lovedOne];
  [self.navigationController pushViewController:weeklyViewController animated:YES];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)plusButtonPressed {
  UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Add a Loved One" message:@"\n \n \n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
  _nameField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
  _nameField.textColor = [UIColor blackColor];
  _nameField.backgroundColor = [UIColor whiteColor];
  _nameField.placeholder = @"Name";
  _nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
  _nameField.leftViewMode = UITextFieldViewModeAlways;
  _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(12, 80, 260, 25)];
  _phoneField.textColor = [UIColor blackColor];
  _phoneField.backgroundColor = [UIColor whiteColor];
  _phoneField.placeholder = @"Phone #";
  _phoneField.keyboardType = UIKeyboardTypePhonePad;
  _phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
  _phoneField.leftViewMode = UITextFieldViewModeAlways;
  [alertview addSubview:_nameField];
  [alertview addSubview:_phoneField];
  [alertview setTransform:CGAffineTransformMakeTranslation(0, 80)];
  [alertview show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
    NSString *nameEntered = [_nameField text];
    NSString *phoneEntered = [_phoneField text];
    
    PFObject *lovedOne = [PFObject objectWithClassName:@"Loved_Ones"];
    [lovedOne setObject:nameEntered forKey:@"name"];
    [lovedOne setObject:phoneEntered forKey:@"phoneNumber"];
    [lovedOne setObject:[PFUser currentUser].objectId forKey:@"associatedUser"];
    [lovedOne saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (!error) {
        [self reloadTableViewWithNewLovedOne:YES];
      } else {
        NSLog(@"Error: %@, %@", error, [error description]);
      }
    }];
  }
}

@end
