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
    
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestionsFromParse()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "submitAnswers:")
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
        
            self.answersTable.answers = results!
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
    
    func submitAnswers(sender: UIBarButtonItem) {
        computeScore()
        
        if questionIndex >= questionArray.count - 1 {
            save()

            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let resultsView = storyboard.instantiateViewControllerWithIdentifier("navigatorToResults") as! UINavigationController
            let resultsController = resultsView.topViewController as! ResultsController
            resultsController.score = score
            resultsController.fromTotal = questionArray.count
            self.presentViewController(resultsView, animated: true, completion: nil)
            
            setAllToInitial()
        
        } else {
            questionIndex++
            answersTable.deleteAllAnswers()
            getQuestionsFromParse()
        }
    }
    
    func save(){
        print("I'll save your \(score)")
    }
    
    func setAllToInitial(){
        score = 0
        questionArray = []
        questionIndex = 0
        answersTable.deleteAllAnswers()
    }
    
    func computeScore(){
        if answersTable.answersAreCorrect(){
            score++
        }
    }
    
}

