//
//  ShowTimeTableViewController.m
//  ShowTime
//
//  Created by Asfanur Arafin on 5/06/2015.
//  Copyright (c) 2015 Asfanur Arafin. All rights reserved.
//

#import "ShowTimeTableViewController.h"
#import "NetworkModelDownloader.h"
#import "ShowData.h"
#import "ShowTableViewCell.h"
#import "BlurredBackgroundView.h"

@interface ShowTimeTableViewController () {
    // Tracks current offset
    int page;
}
// Data that is shown in tableView
@property (nonatomic,strong) NSMutableArray *modelData;
// Checks if tableView is currently refreshing or not
@property (nonatomic) BOOL isRefreshing;

@end

@implementation ShowTimeTableViewController

-(NSMutableArray *)modelData {
    if (!_modelData) {
        _modelData = [[NSMutableArray alloc] init];
    }
    return _modelData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBlurredBackground];
    [self downloadShowsWithOffset:@0];
    
    // UIContentSizeCategoryDidChangeNotification for self sizing cell
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




// -------------------------------------------------------------------------------
//	setBlurredBackground
//  sets tableview background with BlurredBackgroundView
// -------------------------------------------------------------------------------
-(void)setBlurredBackground {
    
    BlurredBackgroundView *blurredBackgroundView = [[BlurredBackgroundView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundView = blurredBackgroundView;
    self.tableView.separatorEffect = [UIVibrancyEffect  effectForBlurEffect:(UIBlurEffect *)blurredBackgroundView.blurView.effect];
    
    
}


// -------------------------------------------------------------------------------
//	downloadShowsWithOffset:offset
//  Download shows information with offset specified
// -------------------------------------------------------------------------------

-(void)downloadShowsWithOffset:(NSNumber *)offset {
    
    [NetworkModelDownloader fetchShowInfoOfOffset:offset
                              WithCompletionBlock:^(NSDictionary *model, NSError *error) {
                                 // Sets isRefreshing to NO to allow refreshing again
                                  self.isRefreshing = NO;
                                  
                                  if (error) {
                                      // Data loading failed so revert back to previous offset
                                      page--;
                                      UIAlertController * alert=   [UIAlertController
                                                                    alertControllerWithTitle:@"Error"
                                                                    message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      UIAlertAction* ok = [UIAlertAction
                                                           actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                      
                                      [alert addAction:ok];
                                      
                                      [self presentViewController:alert animated:YES completion:nil];
                                      
                                      
                                      
                                  } else {
                                      
                                      NSMutableArray *records = [NSMutableArray array];
                                      //Saving Shows data and reload the tableview
                                      for (NSDictionary *row in model[kResults]) {
                                          ShowData *showData = [[ShowData alloc] initWithName:row[kName]
                                                                                withStartTime:row[kStartTime]
                                                                                  withEndTime:row[kEndTime]
                                                                                  withChannel:row[kChannel]
                                                                                   withRating:row[kRating]];
                                          
                                          [records addObject:showData];
                                      }
                                      [self.modelData addObjectsFromArray:records];
                                      
                                      [self.tableView reloadData];
                                   }
                                  
                                  
                                  
                              }];
}


// -------------------------------------------------------------------------------
//	didChangePreferredContentSize:notification
//  Self sizing cell
// -------------------------------------------------------------------------------

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}



#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ShowData *showData = self.modelData[indexPath.row];
    // Set label text color
    cell.backgroundColor = [UIColor clearColor];
    cell.name.textColor = [UIColor whiteColor];
    cell.startTime.textColor = [UIColor whiteColor];
    cell.endTime.textColor  = [UIColor whiteColor];
    cell.channel.textColor = [UIColor whiteColor];
    cell.rating.textColor = [UIColor whiteColor];
    
    cell.name.text = showData.name;
    cell.startTime.text = showData.startTime;
    cell.endTime.text  = showData.endTime;
    cell.channel.text = showData.channel;
    cell.rating.text = showData.rating;
    
    return cell;
}

#pragma mark - scrollView delegate

// -------------------------------------------------------------------------------
//	scrollViewDidScroll:scrollView
//  Download next offset data 
// -------------------------------------------------------------------------------

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        if(self.isRefreshing == NO){
            self.isRefreshing = YES;
            [self downloadShowsWithOffset:[NSNumber numberWithInt:page++]];
            
        }
    }
   
}
 





@end
