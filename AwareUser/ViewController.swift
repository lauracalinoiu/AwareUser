//
//  ViewController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 31/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var infoQuestionLabel: UILabel!
    @IBOutlet weak var answersTable: AnswersTable!
    
    var questionArray: [PFObject] = []
    var questionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestionsFromParse()
    }
    
    func getQuestionsFromParse(){
        ParseAPIClient.sharedInstance.getQuestionsFromParse(){ [unowned self] results, error in
            guard error == nil else {
                return
            }
            guard results != nil else {
                return
            }
            self.questionArray = results
            self.setUpQuestionLabel()
            self.getPossibleAnswersFromParse()
        }
    }
    
    func getPossibleAnswersFromParse(){
        let thisQuestion = self.questionArray[self.questionIndex]
        ParseAPIClient.sharedInstance.getAnswersForQuestion(thisQuestion){ [unowned self] results, error in
            
            guard error == nil else {
                return
            }
            guard results != nil else {
                return
            }
        
            self.answersTable.answer = results!
            dispatch_async(dispatch_get_main_queue()){
               self.answersTable.reloadData()
            }
            
            
        }
    }
    
    func setUpQuestionLabel(){
        if  questionIndex <= questionArray.count-1 {
            let currentQuestion = self.questionArray[self.questionIndex]
            
            dispatch_async(dispatch_get_main_queue()){
                self.infoQuestionLabel.text = "\(self.questionIndex+1)/\(self.questionArray.count)"
                self.questionLabel.text = currentQuestion["text"] as? String
            }
        }
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        if questionIndex >= questionArray.count - 1 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let resultsView = storyboard.instantiateViewControllerWithIdentifier("results")
            self.presentViewController(resultsView, animated: true, completion: nil)
        } else {
            questionIndex++
            setUpQuestionLabel()
        }
    }
    
    
    
    
    
}

