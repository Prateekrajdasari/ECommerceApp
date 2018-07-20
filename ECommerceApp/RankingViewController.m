//
//  RankingViewController.m
//  ECommerceApp
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "RankingViewController.h"

@interface RankingViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSString *keyName;
    
    NSArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDataWithIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentButtonClicked:(id)sender {
    
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    
    [self loadDataWithIndex:(int)segmentControl.selectedSegmentIndex];
}

- (void)loadDataWithIndex:(int)index {
    
    if (index == 0)
        keyName = @"viewCount";
    else if (index == 1)
        keyName = @"orderCount";
    else
        keyName = @"shareCount";
    
    dataArray = [DATAMANAGER getArrayforEntity:@"Product"
                           filterwithPredicate:[NSString stringWithFormat:@"%@ != 0",keyName]
                                   sortWithKey:keyName
                                   isAscending:NO];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TABLECELL"];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TABLECELL"];
    
    Product *product = dataArray[indexPath.row];
    
    cell.textLabel.text = product.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%d",keyName,[[product valueForKey:keyName] intValue]];
    
    return cell;
}

@end

































