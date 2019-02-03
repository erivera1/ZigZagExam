//
//  DetailsViewController.swift
//  ZigZagExam
//
//  Created by Eliric Rivera on 03/02/2019.
//  Copyright © 2019 Eliric Rivera. All rights reserved.
//

import UIKit
import Kingfisher
class DetailsViewController: UIViewController {

    var venue:Venue?
    private var mainView: DetailsView { return view as! DetailsView }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = venue?.name
        self.loadData()
    }
    
    func loadData(){
        self.mainView.lblName.text = venue?.name
        self.mainView.lblAddress.text = venue?.address
//        self.mainView.lblCategory.text = venue?.category
        
//        guard let iconURL = venue?.icon else {
//            return
//        }
//        let url = URL(string: iconURL)
//        self.mainView.imageViewIcon.kf.indicatorType = .activity
//        self.mainView.imageViewIcon.kf.setImage(with: url)
    }
}
