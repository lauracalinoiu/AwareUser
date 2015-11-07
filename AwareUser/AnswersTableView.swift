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
        self.allowsSelectionDuringEditing = true
        self.dataSource = self
        self.delegate = self
        self.editing = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.editing {
            return answers.count+1
        }
        return answers.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("answerCell", forIndexPath: indexPath) as! AnswerCellOnEdit
        if indexPath.row >= answers.count{
            cell.textLabel?.text = "New row"
            cell.answerTextField.hidden = true
        } else {
            cell.answerTextField.text = answers[indexPath.row].text
            cell.isResponseOfQuestion.selected = answers[indexPath.row].isResponse
        }
        cell.showsReorderControl = true
        return cell
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row >= answers.count{
            return UITableViewCellEditingStyle.Insert
        }
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            answers.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        else if editingStyle == .Insert{
            answers.insert(Answer(text: "", isResponse: false), atIndex: indexPath.row)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            if indexPath.row>=answers.count{
                 tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: answers.count, inSection: 0),atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        let paths = NSIndexPath(forRow: answers.count, inSection: 0)
        if editing{
            self.insertRowsAtIndexPaths([paths], withRowAnimation: UITableViewRowAnimation.Top)
            self.scrollToRowAtIndexPath(paths, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        } else {
            self.deleteRowsAtIndexPaths([paths], withRowAnimation: UITableViewRowAnimation.Top)
        }
    }
}

struct Answer{
    var text: String
    var isResponse: Bool = false
}
