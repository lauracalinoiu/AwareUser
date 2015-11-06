//
//  EditQuestionController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 06/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

class EditQuestionController: UITableViewController {

    @IBOutlet weak var questionTextView: UITextView!
    var question: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.text = question["text"] as? String
        self.automaticallyAdjustsScrollViewInsets = false
    }

}
