//
//  OfferViewModel.swift
//  GoEuro
//
//  Created by Artem Shyianov on 1/17/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import Foundation
import SwiftDate

final class OfferViewModel: NSObject {
    private var offer: OfferModel!
    
    var timeText: String? {
        guard let deptTime = offer.departureTime,
            let ariveTime = offer.arrivalTime else {
            return nil
        }
        let timeStr = "\(deptTime) - \(ariveTime)"
        guard let stopsCount = offer.stopsCount, stopsCount > 0 else {
            return timeStr
        }
        return timeStr + "(+\(stopsCount))"
    }
    
    var priceText: String? {
        guard let priceInEuro = offer.price else {
            return nil
        }
        return "€\(priceInEuro)"
    }
    
    var logoURL: URL? {
        guard let logo = offer.logo else {
            return nil
        }
        let logoURLString = logo.replacingOccurrences(of: "{size}", with: "63")
        return URL(string: logoURLString)
    }
    
    var duration: Int? {
        guard let dateStart = self.departureTime,
            let dateEnd = self.arrivalTime else {
                return nil
        }
        
        let components = Calendar.current.dateComponents([.hour, .minute],
                                                         from: dateStart, to: dateEnd)
        
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        return hours*60 + minutes
    }
    
    var durationText: String? {
        guard let dateStart = self.departureTime,
            let dateEnd = self.arrivalTime else {
            return nil
        }
        
        let components = Calendar.current.dateComponents([.hour, .minute],
            from: dateStart, to: dateEnd)

        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        return "Direct \(hours):\(minutes)h"
    }
    
    var departureTime: Date? {
        guard let deptTime = offer.departureTime else {
            return nil
        }
        
        guard let deptDate = OfferViewModel.dateFormater.date(from: deptTime) else {
            return nil
        }
        return deptDate
    }
    
    var arrivalTime: Date? {
        guard let arrivalTime = offer.arrivalTime else {
            return nil
        }
        
        guard let arrivalDate = OfferViewModel.dateFormater.date(from: arrivalTime) else {
            return nil
        }
        return arrivalDate
    }
    
    static var dateFormater: DateFormatter {
        let foramtter = DateFormatter()
        foramtter.locale = Locale(identifier: "en_US")
        foramtter.timeZone = TimeZone.current
        foramtter.timeStyle = .short
        foramtter.dateFormat = "HH:mm"

        return foramtter
    }
    
    init(offer: OfferModel) {
        self.offer = offer
    }
}
