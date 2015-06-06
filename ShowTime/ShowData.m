//
//  ShowData.m
//  ShowTime
//
//  Created by Asfanur Arafin on 6/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "ShowData.h"

@interface ShowData ()

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *startTime;
@property (strong,nonatomic) NSString *endTime;
@property (strong,nonatomic) NSString *channel;
@property (strong,nonatomic) NSString *rating;


@end

@implementation ShowData

-(instancetype)initWithName:(NSString *)name withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime withChannel:(NSString *)channel withRating:(NSString *)rating {
    
    self = [super init];
    if (self) {
        _name = name;
        _startTime = startTime;
        _endTime = endTime;
        _channel = channel;
        _rating = rating;
        
    }
    return self;
    
}



@end
