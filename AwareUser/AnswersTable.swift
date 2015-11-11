//
//  AnswersTable.swift
//  AwareUser
//
//  Created by ab al on 03/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

class AnswersTable: UITableView, UITableViewDelegate, UITableViewDataSource {

    var answers: [PFObject] = [PFObject]()
    var checkboxValues: [Bool] = [Bool]()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 160.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AnswersCell
        
        cell.checkbox.tag = indexPath.row
        cell.checkbox.addTarget(self, action: "checkBoxStateChanged:", forControlEvents: .TouchUpInside)
        cell.checkbox.isChecked = false
        checkboxValues.append(false)
        
        let thisAnswer = answers[indexPath.row]["text"] as! String
        cell.answerLabel.text = thisAnswer
        
        return cell
    }


    func checkBoxStateChanged(sender: CheckBox){
        checkboxValues[sender.tag] = sender.isChecked
    }
    
    func answersAreCorrect() -> Bool{
        var correct = true
        for index in 0 ..< answers.count {
            if let valid = answers[index]["is_answer"] as? Bool{
                if valid != checkboxValues[index]{
                    correct = false
                }
            }
        }
        return correct
    }
    
    func deleteAllAnswers(){
        answers.removeAll()
        checkboxValues.removeAll()
        reloadData()
    }
}
