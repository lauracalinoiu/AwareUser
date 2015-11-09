//
//  EditSuggestionController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 09/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

class EditSuggestionController: UIViewController {
    var suggestion: PFObject!
    @IBOutlet weak var suggestionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestionTextView.text = suggestion["text"] as? String
    }


}
