//
//  AnswersTable.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 03/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

class AnswersTable: UITableView, UITableViewDelegate, UITableViewDataSource {

    var answer: [PFObject] = [PFObject]()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 160.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answer.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AnswersCell
        let thisAnswer = answer[indexPath.row]["text"] as! String
        cell.answerLabel.text = thisAnswer
        
        return cell
    }

}
