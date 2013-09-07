//
//  SplashViewController.m
//  blowfish
//
//  Created by Jeff Grimes on 9/5/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import "SplashViewController.h"
#import "WeeklyViewController.h"
#import "LovedOne.h"

@implementation SplashViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  LovedOne *grandma = [[LovedOne alloc] init];
  grandma.name = @"Grandma Honey BooBoo";
  
  LovedOne *grandpa = [[LovedOne alloc] init];
  grandpa.name = @"Grandpa Stalin";
  
  LovedOne *scrooge = [[LovedOne alloc] init];
  scrooge.name = @"Scrooge McDickWad";
  
  self.lovedOnes = [[NSMutableArray alloc] initWithObjects:grandma, grandpa, scrooge, nil];
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
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
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LovedOne *lovedOne = [self.lovedOnes objectAtIndex:indexPath.row];
  WeeklyViewController *weeklyViewController = [[WeeklyViewController alloc] initWithLovedOne:lovedOne];
  [self.navigationController pushViewController:weeklyViewController animated:YES];
}






@end
