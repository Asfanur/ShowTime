//
//  ShowTimeTests.m
//  ShowTimeTests
//
//  Created by Asfanur Arafin on 5/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NetworkModelDownloader.h"

@interface ShowTimeTests : XCTestCase

@end

@implementation ShowTimeTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
     [super tearDown];
}

// -------------------------------------------------------------------------------
//	testNetworkModelDownloader
//  Check if the data is downloaded correctly and the count is correct 
// -------------------------------------------------------------------------------


-(void)testNetworkModelDownloader {
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Network Model Downloader"];
    [NetworkModelDownloader fetchShowInfoOfOffset:@0 WithCompletionBlock:^(NSDictionary *model, NSError *error) {
        
        XCTAssertNotNil(model, @"data should not be nil");
        XCTAssertNil(error, @"error should be nil");
        XCTAssertEqual([model[kHashCount] intValue],28, @"Wrong Count");
        [completionExpectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
    
}


 
@end
