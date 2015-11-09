//
//  QuestionViewController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 06/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var questionArray: [PFObject] = [PFObject]()
    @IBOutlet weak var questionTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTable.delegate = self
        questionTable.dataSource = self
        questionTable.rowHeight = UITableViewAutomaticDimension
        questionTable.estimatedRowHeight = 160.0
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewQuestionWithAnswers")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getQuestions()
    }
    
    func addNewQuestionWithAnswers(){
        let question = PFObject(className: "question")
        question["text"] = ""
        ParseAPIClient.sharedInstance.saveQuestion(question){ [unowned self] success, err in
            if success {
                self.performSegueWithIdentifier("newQuestion", sender: question)
            }
        }

    }
    
    func getQuestions(){
        ParseAPIClient.sharedInstance.getAllQuestions(){ [unowned self] results, error in
            guard error == nil else {
                return
            }
            guard results != nil else {
                return
            }
            self.questionArray = results
            dispatch_async(dispatch_get_main_queue()){
                self.questionTable.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = questionArray[indexPath.row]["text"] as? String
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editQuestion") {
            let controller = segue.destinationViewController as! EditQuestionController
            if let cell = sender as? UITableViewCell {
                let indexPath = questionTable.indexPathForCell(cell)
                let question = questionArray[indexPath!.row]
                controller.question = question
            }
        } else if (segue.identifier == "newQuestion") {
            let controller = segue.destinationViewController as! EditQuestionController
            if let obj = sender as? PFObject {
                controller.question = obj
            }
        }
    }
    
}
