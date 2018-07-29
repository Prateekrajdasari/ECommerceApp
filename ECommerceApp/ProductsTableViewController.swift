//
//  ProductsTableViewController.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 28/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    var categories: [Categories] = []
    var detailsVC: DetailViewController?
    var subCategoriesTVC: SubCategoriesTableViewController?
    var selectedIndex: IndexPath!
    var selectedSection: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ProductsTableViewController.databaseUpdated(_:)), name: NSNotification.Name(rawValue: "UPDATEDDATABASE"), object: nil)
        
        getCategoriesFromCoreData()
    }
    
    @objc func databaseUpdated(_ notification: Notification) {
        getCategoriesFromCoreData()
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func getCategoriesFromCoreData() {
        if let categoriess = DataManager.sharedInstance.getArrayforEntity("Categories", filterwithPredicate: nil, sortWithKey: "numberOfProducts", isAscending: false) as? [Categories] {
            categories = categoriess
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
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
                let category = categories[selectedIndex.section]
                if let product = category.products?.allObjects[selectedIndex.row] as? Product {
                    detailVC.loadProductDetails(product)
                }
                tableView.deselectRow(at: selectedIndex, animated: false)
            } else if identifier == "SubCategoriesVC" {
                let subCategoriesTVC = segue.destination as! SubCategoriesTableViewController
                subCategoriesTVC.loadCategoryDetails(categories[selectedSection])
            }
        }
    }
}

typealias TableViewMethods = ProductsTableViewController

extension TableViewMethods {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
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
        
        let category = categories[section]
        if category.numberofChildCategories > 0 {
            view.backgroundColor = .cyan
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductsTableViewController.didSelectSectionHeder(_:)))
            
            let arrow = UIImageView(frame: CGRect(x: tableView.frame.size.width - 60, y: 10, width: 33, height: 33))
            arrow.image = UIImage(named: "rightArrow")
            view.addSubview(arrow)
            view .addGestureRecognizer(tapGesture)
        } else {
            view.backgroundColor = .lightGray
        }
        label.text = category.name
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TABLECELL") ?? UITableViewCell(style: .default, reuseIdentifier: "TABLECELL")
        
        let category = categories[indexPath.section]
        let product = category.products?.allObjects[indexPath.row] as? Product
        cell.textLabel?.text = product?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: "showDetailVC", sender: self)
    }
}
