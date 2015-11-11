//
//  ResultsController.swift
//  AwareUser
//
//  Created by ab al on 04/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

//Displays quiz results, together with page control for some suggestions

class ResultsController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var suggestionsLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var score: Int = 0
    var fromTotal: Int = 0
    var suggestions: [PFObject] = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = "Your Score: \(score)/\(fromTotal)"
        getSuggestionsFromParse(){
            if self.suggestions.count > 0 {
                self.suggestionsLabel.text = self.suggestions[0]["text"] as? String
            }
            self.pageControl.numberOfPages = self.suggestions.count
        }
    }
    
    func getSuggestionsFromParse(completionHandler: () -> ()){
        ParseAPIClient.sharedInstance.getSuggestionsWithLimit(){ [unowned self] results, error in
            guard error == nil else {
                return
            }
            self.suggestions = ParseAPIClient.sharedInstance.getFirstShuffled(results, number: ParseAPIClient.sharedInstance.suggestionsMaxResults)
            completionHandler()
        }
    }
    
    @IBAction func changeSuggestion(sender: UIPageControl) {
        suggestionsLabel.text = self.suggestions[sender.currentPage]["text"] as? String
    }
}
