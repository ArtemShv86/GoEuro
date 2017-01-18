//
//  TravelModel.swift
//  GoEuroSample
//
//  Created by Artem Shyianov on 1/17/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import Foundation
import SwiftyJSON

final class OfferModel: NSObject, NSCoding {
    let travelId: Double?
    let departureTime: String?
    let arrivalTime: String?
    let price: String?
    let logo: String?
    let stopsCount: Int?
    
    init?(json: JSON) {
        
        guard let
            travelId = json["id"].double,
            let departureTime = json["departure_time"].string,
            let arrivalTime = json["arrival_time"].string,
            let logo = json["provider_logo"].string,
            let stopsCount = json["number_of_stops"].int
            else {
                return nil
        }
        self.travelId = travelId
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.logo = logo
        if let price = json["price_in_euros"].string {
            self.price = price
        } else {
            self.price = "\(json["price_in_euros"].doubleValue)"
        }
        self.stopsCount = stopsCount
    }
    
    // MARK: NSCoding
    
    required public init?(coder aDecoder: NSCoder) {
        travelId = aDecoder.decodeObject(forKey: "id") as? Double
        departureTime = aDecoder.decodeObject(forKey: "departure_time") as? String
        arrivalTime = aDecoder.decodeObject(forKey: "arrival_time") as? String
        logo = aDecoder.decodeObject(forKey: "provider_logo") as? String
        price = aDecoder.decodeObject(forKey: "price_in_euros") as? String
        stopsCount = aDecoder.decodeObject(forKey: "number_of_stops") as? Int
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(travelId, forKey: "id")
        aCoder.encode(departureTime, forKey: "departure_time")
        aCoder.encode(arrivalTime, forKey: "arrival_time")
        aCoder.encode(logo, forKey: "provider_logo")
        aCoder.encode(price, forKey: "price_in_euros")
        aCoder.encode(stopsCount, forKey: "number_of_stops")
    }
}
