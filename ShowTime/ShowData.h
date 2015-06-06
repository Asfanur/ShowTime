//
//  ShowData.h
//  ShowTime
//
//  Created by Asfanur Arafin on 6/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowData : NSObject

//"name": "The Cleveland Show",
//"start_time": "9:30pm",
//"end_time": "10:00pm",
//"channel": "ELEVEN",
//"rating": "M"

@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSString *startTime;
@property (nonatomic,readonly) NSString *endTime;
@property (nonatomic,readonly) NSString *channel;
@property (nonatomic,readonly) NSString *rating;


-(instancetype)initWithName:(NSString *)name withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime withChannel:(NSString *)channel withRating:(NSString *)rating;


@end
