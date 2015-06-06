//
//  NetworkModelDownloader.h
//  ShowTime
//
//  Created by Asfanur Arafin on 5/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//// This class is responsible for downloading json from network

#import <UIKit/UIKit.h>
#import "ConstantCollection.h"

@interface NetworkModelDownloader : NSObject
typedef void (^ModelCompletionBlock) (NSDictionary *model, NSError * error);
+(void)fetchShowInfoOfOffset:(NSNumber *)offset WithCompletionBlock:(ModelCompletionBlock)completionBlock;
@end
