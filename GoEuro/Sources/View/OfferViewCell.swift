//
//  OfferViewCell.swift
//  GoEuroSample
//
//  Created by Artem Shyianov on 1/17/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import AlamofireImage

class OfferViewCell: UITableViewCell {
    // MARK: Outlets

    @IBOutlet weak var logoProviderImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    // MARK: -
    func bindWithViewModel(viewModel: OfferViewModel) {
        timeLabel.text = viewModel.timeText
        priceLabel.text = viewModel.priceText
        durationLabel.text = viewModel.durationText
        if let logoURL = viewModel.logoURL {
            logoProviderImageView.af_setImage(withURL: logoURL)
        }
    }
}
