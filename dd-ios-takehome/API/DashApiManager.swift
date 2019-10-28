
//
//  DashApiManager.swift
//  dd-ios-takehome
//
//  Created by Christopher Kelley on 10/27/19.
//  Copyright © 2019 Christopher Kelley. All rights reserved.
//

import Foundation

typealias ExploreListResponse = (_ exploreResults: ExploreResultArray?, _ error: Error?) -> Void

class DashApiManager {
    static var baseUrl: String = "https://api.doordash.com/v1/"
    static var instance = DashApiManager()
    private let networkQueue = OperationQueue()
    
    let session = URLSession(configuration: .default)
    
    // Retrieve list of explore items (Resturants) using given latitude & longitude values
    func searchExploreItems(lat: String, lng: String, completion: @escaping ExploreListResponse) {
        let urlCommand = "store_search/"
        let searchRestaurantsURLString = DashApiManager.baseUrl + urlCommand
        
        if var urlComponents = URLComponents(string: searchRestaurantsURLString) {
            let latQueryItem = URLQueryItem(name: "lat", value: lat)
            let lngQueryItem = URLQueryItem(name: "lng", value: lng)
            
            urlComponents.queryItems = [latQueryItem, lngQueryItem]
            
            guard let url = urlComponents.url else { return }
            let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let err = error {
                    completion(nil, err)
                } else if let data = data {
                    do{
                        let result = try JSONDecoder().decode(ExploreResultArray.self, from: data)
                        completion(result, nil)
                    } catch let error {
                    
                        completion(nil, error)
                    }
                } else {
                    completion(nil, error)
                }
            })
            dataTask.resume()
        }
        
    }
}
