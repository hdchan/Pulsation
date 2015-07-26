//
//  ActivityTableViewController.m
//  Sample Project
//
//  Created by Henry Chan on 7/14/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "ActivityTableViewController.h"
#import "StravaAPIClient.h"
#import "ActivityDetailMapViewController.h"

@interface ActivityTableViewController()

@property (nonatomic, strong) StravaAPIClient *straveClient;

@end

@implementation ActivityTableViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.straveClient = [StravaAPIClient sharedClient];
    
    [self.straveClient getCurrentUserActivityWithCompletion:^(BOOL success) {
        
        if (success) {
            
            [self.tableView reloadData];
            
        }

    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.straveClient.currentUserActivity.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    StravaActivity *selectedActivity = self.straveClient.currentUserActivity[indexPath.row];
    
    cell.textLabel.text = selectedActivity.name;

    
    return cell;
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    ActivityDetailMapViewController *destVC = segue.destinationViewController;
    
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    
    StravaActivity *selectedActivity = self.straveClient.currentUserActivity[ip.row];
    
    destVC.activity = selectedActivity;
        
}



@end
