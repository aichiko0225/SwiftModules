//
//  MainViewController.m
//  CCEmptyDataSet
//
//  Created by ash on 2018/3/19.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "EmptyViewController.h"
#import <CCEmptyDataSet.h>
#import "CCEmptyDataSetManager.h"

@interface EmptyViewController ()<CCEmptyDataSetSource, CCEmptyDataSetDelegate>
{
    CCEmptyDataSetManager *_emptyManager;
}
@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, assign) BOOL showMasks;

@end

@implementation EmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _isRefresh = NO;
    _showMasks = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // 同样可以使用CCEmptyDataSetManager 来创建空视图
    
//    _emptyManager = [CCEmptyDataSetManager emptyDataSetWithImage:nil title:@"11111" message:@"22222" buttonTitle:@"333333"];
    
//    self.tableView.emptyDataSetSource = _emptyManager;
//    self.tableView.emptyDataSetDelegate = _emptyManager;
    
    __weak typeof(self) weakSelf = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        _showMasks = NO;
        [strongSelf.tableView reloadData];
    });
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:1.5] forKey:maskViewDuration_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)refreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        _isRefresh = !_isRefresh;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _isRefresh ? 2: 0;
}

- (BOOL)showMaskViewForEmptyDataSet:(UIScrollView *)scrollView {
    return _showMasks;
}

- (EmptyDataSetType)showTypeForEmptyDataSet:(UIScrollView *)scrollView {
    return random()%5;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    _isRefresh = !_isRefresh;
    [self.tableView reloadData];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    _isRefresh = !_isRefresh;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
     }
    // Configure the cell...
    return cell;
}

@end
