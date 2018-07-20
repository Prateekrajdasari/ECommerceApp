//
//  DetailViewController.m
//  ECommerceApp
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () {
    
    Product *productDetail;
    
    Taxes *tax;
    
    NSArray *variantArray;
}

@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property (weak, nonatomic) IBOutlet UITableView *pricesTableView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"EEEE, MMM d, yyyy";
    
    [self.productLabel setText:productDetail.name];
    [self.dateLabel setText:[formatter stringFromDate:productDetail.dateAdded]];
    
    [self.shareLabel setText:[NSString stringWithFormat:@"Shares:%d",productDetail.shareCount]];
    [self.viewLabel setText:[NSString stringWithFormat:@"Views:%d",productDetail.viewCount]];
    [self.orderLabel setText:[NSString stringWithFormat:@"Orders:%d",productDetail.orderCount]];
    
    [self.pricesTableView reloadData];
}

- (void)loadProductDetails:(Product *)product {
    
    tax = product.taxes;
    
    variantArray = product.variants.allObjects;
    
    productDetail = product;
}

#pragma mark - Table View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return variantArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRICESCELL"];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PRICESCELL"];
    
    UILabel *colorLabel = [cell.contentView viewWithTag:1];
    UILabel *sizeLabel = [cell.contentView viewWithTag:2];
    UILabel *priceLabel = [cell.contentView viewWithTag:3];
    UILabel *taxlabel = [cell.contentView viewWithTag:4];
    UILabel *totalLabel = [cell.contentView viewWithTag:5];
    
    Variant *variant = variantArray[indexPath.row];
    
    [colorLabel setText:variant.color];
    [sizeLabel setText:[NSString stringWithFormat:@"%d",variant.size]];
    [priceLabel setText:[NSString stringWithFormat:@"%d",variant.price]];
    [taxlabel setText:[NSString stringWithFormat:@"%.02f",tax.value]];
    [totalLabel setText:[NSString stringWithFormat:@"%.02f",(variant.price*tax.value)]];
    
    return cell;
}

@end
































