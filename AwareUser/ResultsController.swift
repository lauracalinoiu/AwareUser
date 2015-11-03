//
//  ResultsController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 04/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit

class ResultsController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    var score: Int = 0
    var fromTotal: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = "Your Score: \(score)/\(fromTotal)"
    }
}
