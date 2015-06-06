//
//  ConstantCollection.h
//  ShowTime
//
//  Created by Asfanur Arafin on 5/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//This Class holds the requred constants

#import <Foundation/Foundation.h>

@interface ConstantCollection : NSObject

//URL and JSON constants 
#define kBaseURL @"http://www.whatsbeef.net/wabz/guide.php?start="
#define kName @"name"
#define kStartTime @"start_time"
#define kEndTime @"end_time"
#define kChannel @"channel"
#define kRating @"rating"
#define kResults @"results"
#define kHashCount @"count"

//The following error domain is predefined.
extern NSString * const AsfanurArafinErrorDomain;


@end
