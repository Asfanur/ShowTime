//
//  ShowTableViewCell.h
//  ShowTime
//
//  Created by Asfanur Arafin on 6/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import <UIKit/UIKit.h>

//This class displays showtime data

@interface ShowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *channel;
@property (weak, nonatomic) IBOutlet UILabel *rating;

@end
