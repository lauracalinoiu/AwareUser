//
//  EditQuestionController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 06/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

class EditQuestionController: UITableViewController, SegueDelegate, MessageDelegate{
    
    @IBOutlet weak var questionTextView: UITextView!
    var question: PFObject!
    @IBOutlet weak var answersTableView: AnswersTableView!
    var cellId: Int = 0
    var editableCell: AnswerCellOnEdit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.text = question["text"] as? String
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "onEdit:")
        answersTableView.delegateForSegue = self
        getAnswers()
    }
    
    func getAnswers(){
        ParseAPIClient.sharedInstance.getAnswersForQuestion(question){
            [unowned self] results, error in
            
            guard error == nil else {
                return
            }
            guard results != nil else {
                return
            }
            self.answersTableView.answers = results.map{ ( parseObj) -> Answer in
                return Answer( text: parseObj["text"] as! String, isResponse: parseObj["is_answer"] as! Bool)
            }
            dispatch_async(dispatch_get_main_queue()){
                self.answersTableView.reloadData()
            }
        }
    }
    
    func onEdit(sender: AnyObject){
        if (self.answersTableView.editing) {
            self.answersTableView.setEditing(false, animated: false)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "onEdit:")
            questionTextView.editable = false
            saveData()
        } else {
            self.answersTableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "onEdit:")
            questionTextView.editable = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editAnswer" {
            let vc = segue.destinationViewController as! EditAnswerController
            let row = sender as! Int
            editableCell = answersTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as! AnswerCellOnEdit
            vc.answerText = editableCell.answerButton.titleLabel?.text
            vc.delegateForMessage = self
        }
    }
    
    func performSegue(row: Int) {
        performSegueWithIdentifier("editAnswer", sender: row)
    }
    
    func saveData(){
        answersTableView.clearEmptyRows()
        answersTableView.reloadData()
    }
    
    func storeMessage(text: String) {
        editableCell.answerButton.setTitle(text, forState: .Normal)
    }
}

protocol MessageDelegate{
    func storeMessage(text: String)
}

