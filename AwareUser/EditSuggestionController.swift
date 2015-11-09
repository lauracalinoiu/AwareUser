//
//  EditSuggestionController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 09/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

class EditSuggestionController: UIViewController, UITextViewDelegate {
    var suggestion: PFObject!
    @IBOutlet weak var suggestionTextView: UITextView!
    var fromNewSuggestionSegue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestionTextView.text = suggestion["text"] as? String
        navigationItem.rightBarButtonItem = editButtonItem()
        suggestionTextView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if fromNewSuggestionSegue {
            editing = true
        }
    }
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
            suggestionTextView.editable = true
            suggestionTextView.becomeFirstResponder()
        } else {
            suggestionTextView.editable = false
            saveInDb()
            fromNewSuggestionSegue = false
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        suggestion["text"] = textView.text
    }
    
    func saveInDb(){
        ParseAPIClient.sharedInstance.saveSuggestion(suggestion){_,_ in 
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
