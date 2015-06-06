//
//  NetworkModelDownloader.m
//  ShowTime
//
//  Created by Asfanur Arafin on 5/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
////  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "NetworkModelDownloader.h"

@interface NetworkModelDownloader()
typedef void (^DownloadCompletionBlock) (NSData *data, NSURLResponse *response, NSError *error);
@end


@implementation NetworkModelDownloader

// -------------------------------------------------------------------------------
//	fetchCountryInfoWithCompletionBlock:completionBlock
//  Convenience method to get the json data about showtime
// -------------------------------------------------------------------------------

+(void)fetchShowInfoOfOffset:(NSNumber *)offset WithCompletionBlock:(ModelCompletionBlock)completionBlock {
    
    NSString *queryString = [NSString stringWithFormat:@"%@%@",kBaseURL,offset];
    [self fetchQuery:queryString withCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completionBlock(nil,error);
        }
        //Parse the json data and return the callback 
        else {
             NSDictionary *mainDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions
                                                                          error:&error];
            completionBlock(mainDictionary,error);
            
        }
        
        
        
    }];
    
    
}

// -------------------------------------------------------------------------------
//	fetchQuery:withCompletionBlock:completionBlock
//  Common gateway to get the json data
// -------------------------------------------------------------------------------
+(void)fetchQuery:(NSString *)query withCompletionBlock:(DownloadCompletionBlock)completionBlock {
    
     NSURLSession *session = [NSURLSession sharedSession];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[session dataTaskWithURL:[NSURL URLWithString:[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (!error) {
                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                    NSIndexSet *acceptableStatusCodes =  [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
                    //If no error and the response is in range between 200 and 100 then callback with good data
                    if ( [acceptableStatusCodes containsIndex:(NSUInteger)httpResp.statusCode] && data) {
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(data,response,error);
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            
                        });
                        
                    }
                    //If response if not in the range then create custom error
                    else {
                        NSDictionary *userInfo = @{
                                                   NSLocalizedDescriptionKey: NSLocalizedString([NSHTTPURLResponse localizedStringForStatusCode:httpResp.statusCode] , nil),
                                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The data might be incorrect", nil),
                                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please check your data and try again", nil)
                                                   };
                        NSError *customError = [NSError errorWithDomain:AsfanurArafinErrorDomain
                                                                   code:-55
                                                               userInfo:userInfo];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(data,response,customError);
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            
                        });
                        
                    }
                }
                //If error exists then send the callback with error
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(data,response,error);
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                    });
                    
                    
                    
                }
            }] resume];
    
    
    
}



@end
