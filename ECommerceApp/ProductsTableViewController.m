//
//  ProductsTableViewController.m
//  ECommerceApp
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "ProductsTableViewController.h"
#import "SubCategoriesTableViewController.h"
#import "DetailViewController.h"

@interface ProductsTableViewController () {
    
    NSArray *categories;
    
    DetailViewController *detailsVC;
    
    SubCategoriesTableViewController *subCategoriesTVC;
}

@end

@implementation ProductsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(databaseUpdated:) name:@"UPDATEDDATABASE" object:nil];
    
    [self getCategoriesFromCoreData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)databaseUpdated:(NSNotification *) notification {
    
    [self.tableView reloadData];
}

- (void)getCategoriesFromCoreData {
    
    categories = [DATAMANAGER getArrayforEntity:@"Categories"
                            filterwithPredicate:nil
                                    sortWithKey:nil
                                    isAscending:NO];
    
    categories = [categories sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"numberOfProducts" ascending:NO]]];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Categories *category = categories[section];
    
    NSArray *products = category.products.allObjects;
    
    return products.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    
    view.tag = section;
    
    [view setUserInteractionEnabled:YES];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 40)];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    label.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:label];
    
    Categories *category = categories[section];
    
    if (category.numberofChildCategories > 0) {
        
        [view setBackgroundColor:[UIColor cyanColor]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectSectionHeder:)];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-60, 10, 33, 33)];
        
        arrow.image = [UIImage imageNamed:@"rightArrow"];
        
        [view addSubview:arrow];
        
        [view addGestureRecognizer:tapGesture];
    } else {
        
        [view setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    label.text = category.name;
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TABLECELL" forIndexPath:indexPath];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TABLECELL"];
    
    Categories *category = categories[indexPath.section];
    
    NSArray *products = category.products.allObjects;
    
    Product *product = products[indexPath.row];
    
    cell.textLabel.text = product.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!detailsVC)
        detailsVC = [APPDELEGATE.storyBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Product *product = [DATAMANAGER getArrayforEntity:@"Product"
                                  filterwithPredicate:[NSString stringWithFormat:@"name MATCHES '%@'",cell.textLabel.text]
                                          sortWithKey:nil isAscending:NO].lastObject;
    
    [detailsVC loadProductDetails:product];
    
    [self.navigationController pushViewController:detailsVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didSelectSectionHeder:(UITapGestureRecognizer *)tapGesture {
    
    if (!subCategoriesTVC)
        subCategoriesTVC = [APPDELEGATE.storyBoard instantiateViewControllerWithIdentifier:@"SubCategoriesTableViewController"];
    
    [subCategoriesTVC loadCategoryDetails:categories[tapGesture.view.tag]];
    [self.navigationController pushViewController:subCategoriesTVC animated:YES];
}


@end
