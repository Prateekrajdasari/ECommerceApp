//
//  DetailViewController.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 28/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    fileprivate var productDetail: Product!
    fileprivate var tax: Taxes?
    fileprivate var variantArray: [Variant] = []
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var pricesTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        
        productLabel.text = productDetail.name
        dateLabel.text = formatter.string(from: productDetail.dateAdded as Date? ?? Date())
        shareLabel.text = "Shares: \(productDetail.shareCount)"
        viewLabel.text = "Views: \(productDetail.viewCount)"
        orderLabel.text = "Orders: \(productDetail.orderCount)"
        pricesTableView.reloadData()
    }
    
    func loadProductDetails(_ product: Product) {
        productDetail = product
        tax = product.taxes
        variantArray = product.variants?.allObjects as? [Variant] ?? []
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variantArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PRICESCELL") ?? UITableViewCell(style: .default, reuseIdentifier: "PRICESCELL")
        let colorLabel = cell.contentView.viewWithTag(1) as? UILabel
        let sizeLabel = cell.contentView.viewWithTag(2) as? UILabel
        let priceLabel = cell.contentView.viewWithTag(3) as? UILabel
        let taxlabel = cell.contentView.viewWithTag(4) as? UILabel
        let totalLabel = cell.contentView.viewWithTag(5) as? UILabel
        
        let variant = variantArray[indexPath.row]
        colorLabel?.text = variant.color
        sizeLabel?.text = "\(variant.size)"
        priceLabel?.text = "\(variant.price)"
        taxlabel?.text = String(format: "%.02f", tax?.value ?? 0)
        totalLabel?.text = String(format: "%.02f", (Float(variant.price) + (((tax?.value ?? 0)*Float(variant.price))/100)))
        
        return cell
    }
}
