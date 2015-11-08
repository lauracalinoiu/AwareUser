//
//  AnswersTableView.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 07/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit

class AnswersTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var answers: [Answer] = [Answer]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.editing == true {
            return answers.count + 1
        } else {
            return answers.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("answerCell", forIndexPath: indexPath) as! AnswerCellOnEdit
        if indexPath.row >= answers.count {
            cell.textLabel?.text = "insert new row"
        } else {
            cell.textLabel?.text = ""
            cell.answerLabel.text = answers[indexPath.row].text
            cell.isResponseOfQuestion.on = answers[indexPath.row].isResponse
            cell.isResponseOfQuestion.enabled = tableView.editing
        }
        cell.showsReorderControl = true
        return cell
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            answers.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        else if editingStyle == .Insert{
            answers.append(Answer(text: "", isResponse: false))
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: answers.count, inSection: 0), atScrollPosition: .Top, animated: true)
        }
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if tableView.editing{
            if indexPath.row >= answers.count{
                return .Insert
            }
            return .Delete
        }
        return .None
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing{
            self.insertRowsAtIndexPaths([NSIndexPath(forRow: answers.count, inSection: 0)], withRowAnimation: .Top)
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: answers.count, inSection: 0), atScrollPosition: .Top, animated: true)
            reloadData()
        } else {
            self.deleteRowsAtIndexPaths([NSIndexPath(forRow: answers.count, inSection: 0)], withRowAnimation: .Top)
        }
    }
    
    func clearEmptyRows(){
        
        for a in answers {
            print(a.text)
        }
        
        answers = answers.filter(){
            $0.text != ""
        }
        
        for a in answers {
            print(a.text)
        }
    }
}

struct Answer{
    var text: String
    var isResponse: Bool = false
}
