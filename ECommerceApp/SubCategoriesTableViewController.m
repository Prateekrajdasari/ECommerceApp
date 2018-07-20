//
//  SubCategoriesTableViewController.m
//  ECommerceApp
//
//  Created by Prateek Raj on 20/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "SubCategoriesTableViewController.h"
#import "DetailViewController.h"

@interface SubCategoriesTableViewController () {
    
    SubCategoriesTableViewController *subCategoriesTVC;
    
    DetailViewController *detailsVC;
    
    Categories *mainCategory;
    
    NSArray *productsArray;
    NSArray *categoriesArray;
}

@end

@implementation SubCategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCategoryDetails:(Categories *)category{
    
    mainCategory = category;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    categoriesArray = mainCategory.childCategories.allObjects;
    
    if (categoriesArray.count > 0)
        return categoriesArray.count;
    else
        return 1;
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
    
    if (mainCategory.numberofChildCategories > 0) {
        
        NSArray *childCategories = mainCategory.childCategories.allObjects;
        
        ChildCategories *childCategory = childCategories[section];
        
        Categories *category = [DATAMANAGER getArrayforEntity:@"Categories"
                                          filterwithPredicate:[NSString stringWithFormat:@"categoryId == %d",childCategory.categoryId]
                                                  sortWithKey:nil isAscending:NO].lastObject;
        
        if (category.numberofChildCategories > 0) {
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectSectionHeder:)];
            
            [view addGestureRecognizer:tapGesture];
            [view setBackgroundColor:[UIColor cyanColor]];
            
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-60, 10, 33, 33)];
            
            arrow.image = [UIImage imageNamed:@"rightArrow"];
            
            [view addSubview:arrow];
        } else {
            [view setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        label.text = category.name;
    } else {
        
        [view setBackgroundColor:[UIColor lightGrayColor]];
        label.text = mainCategory.name;
    }
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (mainCategory.numberofChildCategories > 0) {
        
        NSArray *childCategories = mainCategory.childCategories.allObjects;
        
        ChildCategories *childCategory = childCategories[section];
        
        Categories *category = [DATAMANAGER getArrayforEntity:@"Categories"
                                          filterwithPredicate:[NSString stringWithFormat:@"categoryId == %d",childCategory.categoryId]
                                                  sortWithKey:nil isAscending:NO].lastObject;
        
        return category.numberOfProducts;
    } else {
        
        productsArray = mainCategory.products.allObjects;
        return productsArray.count;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CATEGORYDETAILCELL"];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CATEGORYDETAILCELL"];
    
    if (mainCategory.numberofChildCategories > 0) {
        
        NSArray *childCategories = mainCategory.childCategories.allObjects;
        
        ChildCategories *childCategory = childCategories[indexPath.section];
        
        Categories *categories = [DATAMANAGER getArrayforEntity:@"Categories"
                                            filterwithPredicate:[NSString stringWithFormat:@"categoryId == %d",childCategory.categoryId]
                                                    sortWithKey:nil isAscending:NO].lastObject;
        
        Product *product = categories.products.allObjects[indexPath.row];
        
        cell.textLabel.text = product.name;
    } else {
        
        NSArray *productsArray = mainCategory.products.allObjects;
        Product *product = productsArray[indexPath.row];
        
        cell.textLabel.text = product.name;
    }
    
    return cell;
}

- (void)didSelectSectionHeder:(UITapGestureRecognizer *)tapGesture {
    
    if (!subCategoriesTVC)
        subCategoriesTVC = [APPDELEGATE.storyBoard instantiateViewControllerWithIdentifier:@"SubCategoriesTableViewController"];
    
    NSArray *subviews = tapGesture.view.subviews;
    
    UILabel *textLabel = nil;
    
    for (UIView *subview in subviews) {
        
        if ([subview isKindOfClass:[UILabel class]]) {
            
            textLabel = (UILabel *)subview;
            break;
        }
    }
    
    NSString *categoryName = textLabel.text;
    
    Categories *category = [DATAMANAGER getArrayforEntity:@"Categories"
                                      filterwithPredicate:[NSString stringWithFormat:@"name MATCHES '%@'",categoryName]
                                              sortWithKey:nil isAscending:NO].lastObject;
    
    [subCategoriesTVC loadCategoryDetails:category];
    [self.navigationController pushViewController:subCategoriesTVC animated:YES];
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


@end


















