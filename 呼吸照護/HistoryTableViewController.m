//
//  HistoryTableViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/11/24.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryRoomData.h"
#import "MainViewController.h"
#import "HistoryCollectionViewController.h"
#import "WebAPI.h"

@interface HistoryTableViewController () <WebAPIDelegate>

@end

@implementation HistoryTableViewController {
    UIRefreshControl *refreshControl;
    NSMutableArray *dataArray;
    WebAPI *api;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    dataArray = [[NSMutableArray alloc] init];
    api = [[WebAPI alloc] initWithServerPath:((MainViewController *)self.parentViewController.parentViewController).serverPath];
    api.delegate = self;
    
    [api getHistoryByRoomNo:@""];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refreshControlRequest)
             forControlEvents:UIControlEventValueChanged];
    
    NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"下拉更新資料"];
    refreshControl.attributedTitle = a;
    
    self.refreshControl = refreshControl;
}

- (void)refreshControlRequest {
    [self performSelector:@selector(refreshTableViewData) withObject:nil];
}

- (void)refreshTableViewData {
    [api getHistoryByRoomNo:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HistoryCollectionViewController *vc = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    vc.MedicalId = ((HistoryRoomData *)[dataArray objectAtIndex:indexPath.row]).MedicalId;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"Data Cell";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.MedicalId = ((HistoryRoomData *)dataArray[indexPath.row]).MedicalId;
    cell.PatientName.text = ((HistoryRoomData *)dataArray[indexPath.row]).Name;
    cell.BedNo.text = ((HistoryRoomData *)dataArray[indexPath.row]).BedNo;
    cell.LastDateTime.text = ((HistoryRoomData *)dataArray[indexPath.row]).LastRespiratoryTime;
    
    return cell;
}

#pragma mark - WebAPIDelegate
- (void)historyListDelegate:(NSArray *)historyList {
    dataArray = [NSMutableArray arrayWithArray:historyList];
    [self.tableView reloadData];
    
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

@end
