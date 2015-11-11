//
//  ParseAPIClient.swift
//  AwareUser
//
//  Created by ab al on 02/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation
import Parse
import GameplayKit


//It allows comunication with Parse db
//On Parse there are 3 tables: - question, answer & suggestion
//It allows saving, retriving and updates on data
class ParseAPIClient {
    
    let NETWORK_INACCESSIBLE = "The network was inaccesible"
    let questionQueryLimit = 10
    let suggestionQueryLimit = 10
    let questionsMaxResults = 3
    let suggestionsMaxResults = 3
    
    func getQuestionsWithLimit(completionHandler: (result: [PFObject]!, error: String?) -> Void){
        let query = PFQuery(className: "question")
        query.limit = questionQueryLimit
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objectsUnwrapped = objects {
                    completionHandler(result: objectsUnwrapped, error: nil)
                }
            } else {
                completionHandler(result: nil, error: self.NETWORK_INACCESSIBLE)
            }
        }
    }
    func getAllQuestions(completionHandler: (result: [PFObject]!, error: String?) -> Void){
        let query = PFQuery(className: "question")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objectsUnwrapped = objects {
                    completionHandler(result: objectsUnwrapped, error: nil)
                }
            } else {
                completionHandler(result: nil, error: self.NETWORK_INACCESSIBLE)
            }
        }
    }
    
    func saveQuestion(question: PFObject, completionHandler: (success: Bool, error: String!) -> Void){
        question.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                completionHandler(success: true, error: nil)
            } else {
                completionHandler(success: false, error: error?.description)
            }
        }
    }
    
    func saveSuggestion(suggestion: PFObject, completionHandler: (success: Bool, error: String!) -> Void){
        suggestion.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                completionHandler(success: true, error: nil)
            } else {
                completionHandler(success: false, error: error?.description)
            }
        }
    }
    
    func getSuggestionsWithLimit(completionHandler: (result: [PFObject]!, error: String?) -> Void){
        let query = PFQuery(className: "suggestion")
        query.limit = suggestionQueryLimit
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objectsUnwrapped = objects {
                    completionHandler(result: objectsUnwrapped, error: nil)
                }
            } else {
                completionHandler(result: nil, error: self.NETWORK_INACCESSIBLE)
            }
        }
    }
    
    func getAllSuggestions(completionHandler: (result: [PFObject]!, error: String?) -> Void){
        let query = PFQuery(className: "suggestion")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objectsUnwrapped = objects {
                    completionHandler(result: objectsUnwrapped, error: nil)
                }
            } else {
                completionHandler(result: nil, error: self.NETWORK_INACCESSIBLE)
            }
        }
    }

    func getAnswersForQuestion(question: PFObject , completionHandler: (result: [PFObject]!, error: String?) -> Void){
        let relation = question.relationForKey("answers")
        relation.query()?.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objectsUnwrapped = objects {
                    completionHandler(result: objectsUnwrapped, error: nil)
                }
            } else {
                completionHandler(result: nil, error: self.NETWORK_INACCESSIBLE)
            }
        }
    }
    
    func updateAnswersForQuestion(question: PFObject, answers: [Answer]){
        let relation = question.relationForKey("answers")
        let query = relation.query()
        query!.findObjectsInBackgroundWithBlock(){ [unowned self]
            (array: [PFObject]?, error: NSError?) -> Void in
           
            for object in array! {
                relation.removeObject(object)
                object.deleteInBackground()
            }
            self.saveQuestion(question){ _,_ in
            }
            
            for answer in answers{
                let pfAnswer = PFObject(className:"answer")
                pfAnswer["text"] = answer.text
                pfAnswer["is_answer"] = answer.isResponse
                
                pfAnswer.saveInBackgroundWithBlock(){ _, _ in
                    relation.addObject(pfAnswer)
                    self.saveQuestion(question){ _, _ in
                      
                    }
                }
            }
            
        }
        
    }
    
    func getFirstShuffled(objects: [PFObject], number: Int) -> [PFObject]{
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(objects) as! [PFObject]
        return Array<PFObject>(shuffled[0..<number])
    }
    
    func pinLocallyAScore(score: Int, total: Int){
        let gameScore = PFObject(className:"Score")
        gameScore["score"] = score
        gameScore["total"] = total
        gameScore["when"] = NSDate()
        gameScore.pinInBackground()
    }
    
    func getScores(completionHandler: (result: [PFObject]!, error: String?) -> Void){
        let query = PFQuery(className: "Score")
        query.fromLocalDatastore()
        query.orderByDescending("when")
        query.findObjectsInBackgroundWithBlock{ [unowned self]
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objectsUnwrapped = objects {
                    completionHandler(result: objectsUnwrapped, error: nil)
                }
            } else {
                completionHandler(result: nil, error: self.NETWORK_INACCESSIBLE)
            }
        }
    }
    
    class var sharedInstance: ParseAPIClient{
        struct Static{
            static let instance: ParseAPIClient = ParseAPIClient()
        }
        return Static.instance
    }
    
}
