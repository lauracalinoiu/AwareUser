//
//  HistoryViewController.swift
//  AwareUser
//
//  Created by ab al on 04/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

//All scores retrieved from phone memory - Parse helps here once again, because it can save also on web
//or locally, on the phone memory. Data displayed is score, from total obtained on a date. 

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var historyScoresTable: UITableView!
    var historyScores: [PFObject] = [PFObject]()
    private static var dateFormatter: NSDateFormatter{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .ShortStyle
            dateFormatter.timeStyle = .ShortStyle
        return dateFormatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyScoresTable.delegate = self
        historyScoresTable.dataSource = self
        
        retrieveScores()
    }

    func retrieveScores(){
        ParseAPIClient.sharedInstance.getScores{ [unowned self] results, error in
            guard error == nil else {
                return
            }
            guard results != nil else {
                return
            }
            self.historyScores = results
            dispatch_async(dispatch_get_main_queue()){
                self.historyScoresTable.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyScores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath)
        let scoreObj = historyScores[indexPath.row]
        let score = scoreObj["score"] as! Int
        let total = scoreObj["total"] as! Int
        
        cell.textLabel?.text = "\(score) / \(total)"
        if let whenScoreWasCreated = scoreObj["when"] as? NSDate{
            let dateAsString = HistoryViewController.dateFormatter.stringFromDate(whenScoreWasCreated)
            cell.detailTextLabel?.text = "\(dateAsString)"
        }
        
        return cell
    }
}
