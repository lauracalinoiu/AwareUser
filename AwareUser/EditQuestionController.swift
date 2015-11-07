//
//  EditQuestionController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 06/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

class EditQuestionController: UITableViewController{
    
    @IBOutlet weak var questionTextView: UITextView!
    var question: PFObject!
    @IBOutlet weak var answersTableView: AnswersTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.text = question["text"] as? String
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "onEdit:")
    }
    
    func onEdit(sender: AnyObject){
        if (self.tableView.editing) {
            self.answersTableView.setEditing(false, animated: false)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "onEdit:")
            questionTextView.editable = false
        } else {
            self.answersTableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "onEdit:")
            questionTextView.editable = true
        }
    }
}

