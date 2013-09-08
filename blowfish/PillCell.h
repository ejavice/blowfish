//
//  PillCell.h
//  blowfish
//
//  Created by Jeff Grimes on 9/7/13.
//  Copyright (c) 2013 Jeff Grimes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PillCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIButton *landlineButton;
@property (nonatomic, retain) IBOutlet UILabel *pillNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *morningButton;
@property (nonatomic, retain) IBOutlet UIButton *afternoonButton;
@property (nonatomic, retain) IBOutlet UIButton *eveningButton;
@property (nonatomic, retain) IBOutlet UIButton *sundayButton;
@property (nonatomic, retain) IBOutlet UIButton *mondayButton;
@property (nonatomic, retain) IBOutlet UIButton *tuesdayButton;
@property (nonatomic, retain) IBOutlet UIButton *wednesdayButton;
@property (nonatomic, retain) IBOutlet UIButton *thursdayButton;
@property (nonatomic, retain) IBOutlet UIButton *fridayButton;
@property (nonatomic, retain) IBOutlet UIButton *saturdayButton;

- (IBAction)dayPressed:(id)sender;
- (IBAction)pillTimePressed:(id)sender;
- (IBAction)landlineButtonPressed:(id)sender;

@end
