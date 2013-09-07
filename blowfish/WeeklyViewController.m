//
//  WeeklyViewController.m
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import <Parse/Parse.h>

#import "WeeklyViewController.h"

static const float topBarHeight = 60;
static const float topBarButtonSidePadding = 8;
static const float topBarButtonSize = 36;

@interface WeeklyViewController () {
  UITableView *_tableView;
  UIButton *_backButton;
  UIButton *_plusButton;
  
  LovedOne *_lovedOne;
}

@end

@implementation WeeklyViewController

- (id)initWithLovedOne:(LovedOne *)lovedOne {
  if (self = [super init]) {
    _lovedOne = lovedOne;
    self.pills = [[NSMutableArray alloc] init];
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
  titleLabel.text = _lovedOne.name;
  titleLabel.font = [UIFont systemFontOfSize:23];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.backgroundColor = [UIColor orangeColor];
  [self.view addSubview:titleLabel];
  
  _backButton = [[UIButton alloc] initWithFrame:CGRectMake(topBarButtonSidePadding, (topBarHeight - topBarButtonSize) / 2, topBarButtonSize, topBarButtonSize)];
  [_backButton setImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
  [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_backButton];
  
  _plusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - topBarButtonSidePadding - topBarButtonSize, (topBarHeight - topBarButtonSize) / 2, topBarButtonSize, topBarButtonSize)];
  [_plusButton setImage:[UIImage imageNamed:@"plus-icon.png"] forState:UIControlStateNormal];
  [_plusButton addTarget:self action:@selector(plusButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_plusButton];
  
  [self reloadTableView];
}

- (void)reloadTableView {
  PFQuery *query = [PFQuery queryWithClassName:@"Pills_To_Take"];
  [query whereKey:@"lovedOne" equalTo:_lovedOne.objectId];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      for (PFObject *object in objects) {
        NSString *objectId = object.objectId;
        NSString *name = [object objectForKey:@"pillName"];
        if (![self pillAlreadyExists:objectId]) {
          Pill *pill = [[Pill alloc] initWithObjectId:objectId name:name];
          [self.pills addObject:pill];
        }
      }
      [_tableView reloadData];
    } else {
      NSLog(@"Error: %@, %@", error, [error userInfo]);
    }
  }];
}

- (BOOL)pillAlreadyExists:(NSString *)objectId {
  for (Pill *pill in self.pills) {
    if ([pill.objectId isEqualToString:objectId]) {
      return YES;
    }
  }
  return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.pills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  Pill *pill = [self.pills objectAtIndex:indexPath.row];
  cell.textLabel.text = pill.name;
  cell.textLabel.font = [UIFont systemFontOfSize:19];
  cell.selectionStyle = UITableViewCellSelectionStyleGray;
  return cell;
}

- (void)backButtonPressed {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)plusButtonPressed {
  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Medication" message:@"What is the name of the medication?" delegate:self cancelButtonTitle:@"Create" otherButtonTitles:@"Cancel", nil];
  alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 0) {
    NSString *nameEntered = [[alertView textFieldAtIndex:0] text];
    
    PFObject *pill = [PFObject objectWithClassName:@"Pills_To_Take"];
    [pill setObject:nameEntered forKey:@"pillName"];
    [pill setObject:_lovedOne.objectId forKey:@"lovedOne"];
    [pill saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (!error) {
        [self reloadTableView];
      } else {
        NSLog(@"Error: %@, %@", error, [error description]);
      }
    }];
  }
}

@end
