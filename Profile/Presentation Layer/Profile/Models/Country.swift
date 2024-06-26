//
//  Country.swift
//  Profile
//
//  Created by admin on 19.06.2024.
//

import Foundation
import MapKit

struct Country: Identifiable{
//    static func == (lhs: Country, rhs: Country) -> Bool {
//        lhs.id == rhs.id
//    }
    
    var id: String = UUID().uuidString
    var name: String
    var flag: String = "+"
    var coordinate: CLLocationCoordinate2D?
    var isVisited: Bool = false
    var isAddedToBucketList: Bool = false
}
