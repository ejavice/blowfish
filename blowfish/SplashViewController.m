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

static const float topBarHeight = 60;
static const float topBarButtonSidePadding = 11;
static const float topBarButtonSize = 26;

@interface SplashViewController () {
  UITableView *_tableView;
  UIButton *_plusButton;
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
  [self.view setBackgroundColor:[UIColor whiteColor]];

  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - topBarHeight) style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.separatorColor = [UIColor clearColor];
  [self.view addSubview:_tableView];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, topBarHeight)];
  titleLabel.text = @"My Loved Ones";
  titleLabel.font = [UIFont systemFontOfSize:23];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.backgroundColor = [UIColor orangeColor];
  [self.view addSubview:titleLabel];
  
  _plusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - topBarButtonSidePadding - topBarButtonSize, (topBarHeight - topBarButtonSize) / 2, topBarButtonSize, topBarButtonSize)];
  [_plusButton setImage:[UIImage imageNamed:@"plus-icon.png"] forState:UIControlStateNormal];
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
        if (![self lovedOneAlreadyExists:objectId]) {
          LovedOne *lovedOne = [[LovedOne alloc] initWithObjectId:objectId name:name];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.lovedOnes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  LovedOne *lovedOne = [self.lovedOnes objectAtIndex:indexPath.row];
  cell.textLabel.text = lovedOne.name;
  cell.textLabel.font = [UIFont systemFontOfSize:20];
  cell.selectionStyle = UITableViewCellSelectionStyleGray;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LovedOne *lovedOne = [self.lovedOnes objectAtIndex:indexPath.row];
  WeeklyViewController *weeklyViewController = [[WeeklyViewController alloc] initWithLovedOne:lovedOne];
  [self.navigationController pushViewController:weeklyViewController animated:YES];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)plusButtonPressed {
  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Loved One" message:@"What is this person's name?" delegate:self cancelButtonTitle:@"Create" otherButtonTitles:@"Cancel", nil];
  alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 0) {
    NSString *nameEntered = [[alertView textFieldAtIndex:0] text];

    PFObject *lovedOne = [PFObject objectWithClassName:@"Loved_Ones"];
    [lovedOne setObject:nameEntered forKey:@"name"];
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
