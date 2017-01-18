//
//  ViewController.swift
//  GoEuroTest
//
//  Created by Artem Shyianov on 1/17/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import HMSegmentedControl
//import PKHUD

class ViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var travelTableView: UITableView!
    @IBOutlet weak var segmentedControl: HMSegmentedControl!

    //MARK: - Dependencies
    
    private var viewModel: TravelViewModel!
    private let disposeBag = DisposeBag()
    var tableViewData: [OfferViewModel]? {
        didSet {
            travelTableView.reloadData()
        }
    }
    var isUpSorting:Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = TravelViewModel(travelService: RestAPIService())
        convigureView()
        addBindsToViewModel(viewModel: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectTab(self.segmentedControl.selectedSegmentIndex)
    }
    
    private func convigureView() {
        segmentedControl.sectionTitles = ["Train", "Bus", "Flight"]
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15)!
        ]
        segmentedControl.rx.controlEvent(.valueChanged).subscribe { (event) in
            self.isUpSorting = false
            self.selectTab(self.segmentedControl.selectedSegmentIndex)
        }.addDisposableTo(disposeBag)
        sortButton.rx.controlEvent(.touchUpInside).subscribe { (event) in
            self.viewModel.sortSubject.onNext(self.isUpSorting ? .duration : .arrivalTime)
            self.isUpSorting = !self.isUpSorting
        }.addDisposableTo(disposeBag)
        travelTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let alertVC = UIAlertController(
                    title: "Offer details are not yet implemented!",
                    message: nil, preferredStyle: .alert
                )
                alertVC.addAction(
                    UIAlertAction(title: "OK", style: .cancel, handler: nil)
                )
                self.present(alertVC, animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }

    // MARK: - Private
    
    private func addBindsToViewModel(viewModel: TravelViewModel) {
        viewModel.offers.asObservable()
            .bindTo(travelTableView.rx.items(cellIdentifier: "providerCell",
                                             cellType: OfferViewCell.self)) { (row, element, cell) in
                cell.bindWithViewModel(viewModel: element)
            }
            .addDisposableTo(disposeBag)
    }
    
    func selectTab(_ selectedIndex: Int) {
        self.viewModel.optionSubject.onNext(selectedIndex)
    }
}

