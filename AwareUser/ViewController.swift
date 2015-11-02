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
            
            var labels: [UILabel] = [UILabel]()
            var i = 0
            let startY = self.questionLabel.frame.origin.y + self.questionLabel.frame.height
            for answer in results!{
                let label = UILabel(frame: CGRectMake(20, CGFloat(Int(startY)+20+50*i), self.view.frame.width-20, 100 ))
                
                label.numberOfLines = 0
                label.text = answer["text"] as? String
                labels.append(label)
                i++
            }
            
            dispatch_async(dispatch_get_main_queue()){
                for label in labels{
                    self.view.addSubview(label)
                }
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

