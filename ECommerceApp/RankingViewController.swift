//
//  RankingViewController.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 28/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

import UIKit
import CoreData

class RankingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex: IndexPath!
    var keyName: String!
    var dataArray: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataWithIndex(0)
    }
    
    @IBAction func segmentButtonClicked(_ sender: UISegmentedControl) {
        loadDataWithIndex(sender.selectedSegmentIndex)
    }
    
    fileprivate func loadDataWithIndex(_ index: Int) {
        switch index {
        case 0:
            keyName = "viewCount";
        case 1:
            keyName = "orderCount";
        default:
            keyName = "shareCount";
        }
        if let name = keyName, let products = DataManager.sharedInstance.getArrayforEntity("Product", filterwithPredicate: "\(name) != 0", sortWithKey: keyName, isAscending: false) as? [Product] {
            dataArray = products
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "showDetailVC" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.loadProductDetails(dataArray[selectedIndex.row])
            tableView.deselectRow(at: selectedIndex, animated: false)
        }
    }
}

extension RankingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TABLECELL") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "TABLECELL")
        
        let product = dataArray[indexPath.row]
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = "\(keyName!): \(String(describing: product.value(forKey: keyName)!))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: "showDetailVC", sender: self)
    }
}
