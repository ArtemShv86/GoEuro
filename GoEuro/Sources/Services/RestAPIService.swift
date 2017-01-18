//
//  RestAPIService.swift
//  GoEuroTest
//
//  Created by Artem Shyianov on 1/17/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire
import SwiftyJSON
import SystemConfiguration

public enum Transport: Int {
    case train
    case bus
    case flight
}

public struct RestAPIService {
    //MARK: - Dependecies
    
    public struct Constants {
        static let baseAPIURL = "https://api.myjson.com/"
    }
    
    enum APIError: Error {
        case cannotParse
        case connectionProblem
    }
    
    enum ResourcePath: String {
        case flight = "bins/w60i"
        case train  = "bins/3zmcy"
        case bus    = "bins/37yzm"
        
        var path: String {
            return Constants.baseAPIURL + rawValue
        }
    }

    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    func getOffers(transport: Transport) -> Observable<[OfferModel]> {
        let transportMap:[Transport: ResourcePath] = [
            .flight : .flight,
            .train: .train,
            .bus: .bus
        ]
        if let path = transportMap[transport]?.path
            , let url = URL(string: path) {
            if isInternetAvailable() {
                return json(.get, url).flatMap({
                    (result) -> Observable<[OfferModel]> in
                    guard let array = result as? [Any] else {
                        return Observable.error(APIError.cannotParse)
                    }
                    var offers:[OfferModel] = []
                    for dict in array {
                        if let offer = OfferModel(json: JSON(dict)) {
                            offers.append(offer)
                        }
                    }
                    let data = NSKeyedArchiver.archivedData(withRootObject: offers)
                    UserDefaults.standard.set(data, forKey: "offers")
                    return Observable.just(offers)
                }).observeOn(MainScheduler.instance)
            } else {
                // Load data from cache
                if let data = UserDefaults.standard.object(forKey: "offers") as? Data {
                    let offers = NSKeyedUnarchiver.unarchiveObject(with: data) as? [OfferModel]
                    return Observable.just(offers!)
                } else {
                    return Observable.error(APIError.connectionProblem)
                }
            }
        } else {
            return Observable.empty()
        }
    }
}
