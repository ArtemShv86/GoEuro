//
//  TravelViewModel.swift
//  GoEuroSample
//
//  Created by Artem Shyianov on 1/17/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import Foundation
import RxSwift
import PKHUD

enum SortMode: Int {
    case duration
    case arrivalTime
}
final class TravelViewModel {
    
    //MARK: - Dependecies
    
    private let restAPIService: RestAPIService
    private let disposeBag = DisposeBag()
    
    //MARK: - Model
    
    var offers = Variable([OfferViewModel]())
    var optionSubject = PublishSubject<Int>()
    var sortSubject = PublishSubject<SortMode>()
    
    //MARK: - Set up
    
    init(travelService: RestAPIService) {
        
        self.restAPIService = travelService
        let _ = optionSubject.subscribe(onNext: { (index) in
            let transport = Transport(rawValue: index)!
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()

            let _ = self.restAPIService.getOffers(transport: transport)
            .subscribe(onNext: { (result) in
                var offersModels:[OfferViewModel] = []

                for offer in result {
                    offersModels.append(OfferViewModel(offer: offer))
                }
                
                offersModels = self.sortOffers(offers: offersModels, sortMode:.duration)
                
                self.offers.value = offersModels
                PKHUD.sharedHUD.hide()
            }, onError: { (error) in
                PKHUD.sharedHUD.hide()
            })
        }, onError: { (error) in
            
        })
        
        let _ = sortSubject.subscribe(onNext: { (sorting) in
            let offersModels = self.offers.value
            self.offers.value = self.sortOffers(offers: offersModels, sortMode:sorting)
        }, onError: { (error) in
            
        })
    }
    
    func sortOffers(offers: [OfferViewModel], sortMode: SortMode) -> [OfferViewModel] {
        return offers.sorted(by: { (offer1, offer2) -> Bool in
            if sortMode == .arrivalTime {
                guard let date1 =  offer1.arrivalTime,
                    let date2 = offer2.arrivalTime else {
                        return false
                }
                return date1 < date2
            } else {
                guard let duration1 =  offer1.duration,
                    let duration2 = offer2.duration else {
                        return false
                }
                return duration1 < duration2
            }
            
        })
    }
}
