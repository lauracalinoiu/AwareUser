//
//  SuggestionsViewController.swift
//  AwareUser
//
//  Created by ab al on 09/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

//ViewController that displays whole list of suggestions retrieved from Parse web DB
//It allows clicking on a row, and this one gets to edit the row
//It allows of adding an empty row
class SuggestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var suggestionArray: [PFObject] = [PFObject]()
    @IBOutlet weak var suggestionTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
        suggestionTable.rowHeight = UITableViewAutomaticDimension
        suggestionTable.estimatedRowHeight = 160.0
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewSuggestion")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getSuggestions()
        suggestionTable.reloadData()
    }
    
    
    func addNewSuggestion(){
        let suggestion = PFObject(className: "suggestion")
        suggestion["text"] = ""
        ParseAPIClient.sharedInstance.saveSuggestion(suggestion){ [unowned self] success, err in
            if success {
                self.performSegueWithIdentifier("newSuggestion", sender: suggestion)
            }
        }
        
    }
    
    func getSuggestions(){
        ParseAPIClient.sharedInstance.getAllSuggestions(){ [unowned self] results, error in
            guard error == nil else {
                return
            }
            guard results != nil else {
                return
            }
            self.suggestionArray = results
            dispatch_async(dispatch_get_main_queue()){
                self.suggestionTable.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("suggestionCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = suggestionArray[indexPath.row]["text"] as? String
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editSuggestion") {
            let controller = segue.destinationViewController as! EditSuggestionController
            if let cell = sender as? UITableViewCell {
                let indexPath = suggestionTable.indexPathForCell(cell)
                let suggestion = suggestionArray[indexPath!.row]
                controller.suggestion = suggestion
            }
        } else if (segue.identifier == "newSuggestion") {
            let controller = segue.destinationViewController as! EditSuggestionController
            if let obj = sender as? PFObject {
                controller.suggestion = obj
                controller.fromNewSuggestionSegue = true
            }
        }
    }

}
