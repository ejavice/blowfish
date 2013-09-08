//
//  WeeklyViewController.m
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import <Parse/Parse.h>

#import "WeeklyViewController.h"
#import "PillCell.h"

static const float topBarHeight = 50;
static const float topBarButtonSidePadding = 8;
static const float topBarButtonSize = 26;

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
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"knitting.png"]]];
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - topBarHeight) style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.separatorColor = [UIColor clearColor];
  _tableView.backgroundColor = [UIColor clearColor];
  [_tableView registerNib:[UINib nibWithNibName:@"PillCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PillCellReuseID"];
  [self.view addSubview:_tableView];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, topBarHeight)];
  titleLabel.text = _lovedOne.name;
  titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.backgroundColor = [UIColor orangeColor];
  titleLabel.textColor = [UIColor whiteColor];
  [self.view addSubview:titleLabel];
  
  _backButton = [[UIButton alloc] initWithFrame:CGRectMake(topBarButtonSidePadding, (topBarHeight - topBarButtonSize) / 2, topBarButtonSize, topBarButtonSize)];
  [_backButton setImage:[UIImage imageNamed:@"back-icon-white.png"] forState:UIControlStateNormal];
  [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_backButton];
  
  _plusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - topBarButtonSidePadding - topBarButtonSize, (topBarHeight - topBarButtonSize) / 2, topBarButtonSize, topBarButtonSize)];
  [_plusButton setImage:[UIImage imageNamed:@"plus-icon-white.png"] forState:UIControlStateNormal];
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
        NSString *days = [object objectForKey:@"days"];
        NSString *pillTime = [object objectForKey:@"time"];
        if (![self pillAlreadyExists:objectId]) {
          Pill *pill = [[Pill alloc] initWithObjectId:objectId name:name days:days pillTime:pillTime];
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
  static NSString *CellIdentifier = @"PillCellReuseID";
  
  PillCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[PillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  Pill *pill = [self.pills objectAtIndex:indexPath.row];
  
  cell.pillNameLabel.text = pill.name;
  
  if ([pill.pillTime isEqualToString:@"morning"]) {
    [cell.pillTimeControl setSelectedSegmentIndex:0];
  } else if ([pill.pillTime isEqualToString:@"afternoon"]) {
    [cell.pillTimeControl setSelectedSegmentIndex:1];
  } else {
    [cell.pillTimeControl setSelectedSegmentIndex:2];
  }
  
  if ([pill.days rangeOfString:@"0"].location != NSNotFound) {
    cell.mondayButton.selected = YES;
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 140;
}

- (void)backButtonPressed {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)plusButtonPressed {
  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Medication" message:@"What is the medication's name?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
  alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1) {
    NSString *nameEntered = [[alertView textFieldAtIndex:0] text];
    
    PFObject *pill = [PFObject objectWithClassName:@"Pills_To_Take"];
    [pill setObject:nameEntered forKey:@"pillName"];
    [pill setObject:_lovedOne.objectId forKey:@"lovedOne"];
    [pill setObject:@"0123456" forKey:@"days"];
    [pill setObject:@"morning" forKey:@"time"];
    [pill setObject:_lovedOne.name forKey:@"lovedOneName"];
    [pill setObject:_lovedOne.phoneNumber forKey:@"lovedOneNumber"];
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
