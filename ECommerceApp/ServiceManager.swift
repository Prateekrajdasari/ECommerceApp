//
//  ServiceManager.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 28/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

import Foundation

class ServiceManager {
    public fileprivate(set) static var sharedInstance = ServiceManager()
    
    func getDataFromServer() {
        
        guard let url = URL(string: "https://stark-spire-93433.herokuapp.com/json") else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                print(error)
            } else {
                guard let data = data else { return }
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves), let dataReord = jsonResponse as? DataRecord else { return }
                DataManager.sharedInstance.removeAllExistingData()
                DataManager.sharedInstance.pushDataToCoreData(dataReord)
                
            }
        })
        task.resume()
    }
}
