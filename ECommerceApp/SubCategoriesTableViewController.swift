//
//  SubCategoriesTableViewController.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 28/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

import UIKit

class SubCategoriesTableViewController: UITableViewController {
    
    var subCategoriesTVC: SubCategoriesTableViewController!
    var detailsVC: DetailViewController!
    var mainCategory: Categories!
    var productsArray: [Product] = []
    var categoriesArray: [Categories] = []
    var selectedIndex: IndexPath!
    var selectedSection: Int!
    
    func loadCategoryDetails(_ category: Categories) {
        mainCategory = category
        tableView.reloadData()
    }
    
    func getProductsForSection(_ section: Int) -> [Product] {
        var category: Categories?
        if mainCategory.numberofChildCategories > 0 {
            category = mainCategory.childrens?.allObjects[section] as? Categories
        } else {
            category = mainCategory
        }
        return category?.products?.allObjects as? [Product] ?? []
    }
    
    @objc func didSelectSectionHeder(_ tapGesture: UITapGestureRecognizer) {
        if let tag = tapGesture.view?.tag {
            selectedSection = tag
            performSegue(withIdentifier: "SubCategoriesVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showDetailVC" {
                let detailVC = segue.destination as! DetailViewController
                var product: Product? = nil
                let products = getProductsForSection(selectedIndex.section)
                if products.count > selectedIndex.row {
                    product = products[selectedIndex.row]
                }
                
                if let product = product {
                    detailVC.loadProductDetails(product)
                }
                tableView.deselectRow(at: selectedIndex, animated: false)
            } else if identifier == "SubCategoriesVC" {
                guard mainCategory.numberofChildCategories > selectedSection, let category = mainCategory.childrens?.allObjects[selectedSection] as? Categories else { return }
                let subCategoriesTVC = segue.destination as! SubCategoriesTableViewController
                subCategoriesTVC.loadCategoryDetails(category)
            }
        }
    }
}

typealias TableViewMethodss = SubCategoriesTableViewController

extension TableViewMethodss {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return mainCategory.numberofChildCategories > 0 ? Int(mainCategory.numberofChildCategories) : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getProductsForSection(section).count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44;
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        view.tag = section
        view.isUserInteractionEnabled = true
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        view.addSubview(label)
        
        if (mainCategory.childCategories?.count ?? 0) > 0 {
            let category = mainCategory.childrens?.allObjects[section] as? Categories
            if (category?.childCategories?.count ?? 0) > 0 {
                view.backgroundColor = .cyan
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SubCategoriesTableViewController.didSelectSectionHeder(_:)))
                
                let arrow = UIImageView(frame: CGRect(x: tableView.frame.size.width - 60, y: 10, width: 33, height: 33))
                arrow.image = UIImage(named: "rightArrow")
                view.addSubview(arrow)
                view .addGestureRecognizer(tapGesture)
            } else {
                view.backgroundColor = .lightGray
            }
            label.text = category?.name
        } else {
            view.backgroundColor = .lightGray
            label.text = mainCategory.name
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CATEGORYDETAILCELL") ?? UITableViewCell(style: .default, reuseIdentifier: "CATEGORYDETAILCELL")
        var product: Product?
        if mainCategory.numberofChildCategories > 0 {
            let childCategories = mainCategory.childrens?.allObjects
            let category = childCategories?[indexPath.section] as? Categories
            let products = category?.products?.allObjects
            product = products?[indexPath.row] as? Product
        } else {
            let products = mainCategory.products?.allObjects
            product = products?[indexPath.row] as? Product
        }
        cell.textLabel?.text = product?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: "showDetailVC", sender: self)
    }
    
}
