//
//  EditQuestionController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 06/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

class EditQuestionController: UITableViewController, SegueDelegate, MessageDelegate, UITextViewDelegate{
    
    @IBOutlet weak var questionTextView: UITextView!
    var question: PFObject!
    var questionIndex: Int = 0
    @IBOutlet weak var answersTableView: AnswersTableView!
    var editableRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.text = question["text"] as? String
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "onEdit:")
        answersTableView.delegateForSegue = self
        questionTextView.delegate = self
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
            editableRow = sender as! Int
            vc.answerText = answersTableView.answers[editableRow].text
            vc.delegateForMessage = self
        }
    }
    
    func performSegue(row: Int) {
        performSegueWithIdentifier("editAnswer", sender: row)
    }
    
    func textViewDidChange(textView: UITextView) {
        question["text"] = textView.text
    }
    
    func saveData(){
        answersTableView.clearEmptyRows()
        answersTableView.reloadData()
        ParseAPIClient.sharedInstance.updateAnswersForQuestion(question, answers: answersTableView.answers)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func storeMessage(text: String) {
        print("text  "+text)
        answersTableView.answers[editableRow].text = text
        answersTableView.reloadData()
        editableRow = -1
    }
    
    
}

protocol MessageDelegate{
    func storeMessage(text: String)
}

