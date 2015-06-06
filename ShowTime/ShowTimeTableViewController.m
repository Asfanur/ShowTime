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

@interface ShowTimeTableViewController () {
 int page;
}
@property (nonatomic,strong) NSMutableArray *modelData;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
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
    [self downloadShowsWithOffset:@0];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)startActivityIndicator {
    self.activityIndicator =  [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(self.tableView.center.x, self.tableView.center.y, 100, 100);
    [self.tableView addSubview:self.activityIndicator];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.tableView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.activityIndicator
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.tableView
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1.0
                                   constant:0.0]];
    
    [self.tableView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.activityIndicator
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.tableView
                                   attribute:NSLayoutAttributeCenterX
                                   multiplier:1.0
                                   constant:0.0]];
    [self.activityIndicator startAnimating];
    
    
    
    
}

-(void)stopActivityIndicator {
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
    
}



-(void)downloadShowsWithOffset:(NSNumber *)offset {
    
    [self startActivityIndicator];
    [NetworkModelDownloader fetchShowInfoOfOffset:offset
                              WithCompletionBlock:^(NSDictionary *model, NSError *error) {
                                  self.isRefreshing = NO;
                                  
                                  [self stopActivityIndicator];
                                  
                                  if (error) {
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



#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ShowData *showData = self.modelData[indexPath.row];
    cell.textLabel.text = showData.name;
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        if(self.isRefreshing == NO){
            self.isRefreshing = YES;
            [self downloadShowsWithOffset:[NSNumber numberWithInt:page++]];
             NSLog(@"called %d",page);
        }
    }
}




@end
