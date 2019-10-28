//
//  ExploreItem.swift
//  dd-ios-takehome
//
//  Created by Christopher Kelley on 10/27/19.
//  Copyright © 2019 Christopher Kelley. All rights reserved.
//

import Foundation

typealias ExploreResultArray = [ExploreItem]

struct ExploreItem : Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let deliveryTime: Int?
    let deliveryFee: Int?
    let exploreImageUrl: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case deliveryTime = "asap_time"
        case deliveryFee = "delivery_fee"
        case exploreImageUrl = "cover_img_url"
        case status = "status"
    }

}
