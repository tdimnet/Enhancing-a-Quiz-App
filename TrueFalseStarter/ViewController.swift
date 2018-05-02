//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController {
    
    // Create a new instance of the quiz game class.
    var quiz = Quiz(
        questions: [firstQuestion, secondQuestion, thirdQuestion, fourthQuestion, fifthQuestion, sixthQuestion, seventhQuestion, eighthQuestion, ninthQuestion, tenthQuestion],
        questionsPerRound: 4,
        questionsAsked: 0,
        correctQuestions: 0,
        indexOfSelectedQuestion: 0
    )
    
    // Deals with all the sound needed for the game
    var gameSound: SystemSoundID = 0
    let winningSystemSoundID: SystemSoundID = 1016
    let losingSystemSoundID: SystemSoundID = 1073
    
    // UILabel
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerFeedback: UILabel!
    @IBOutlet weak var answer: UILabel!
    
    // UIButton
    @IBOutlet weak var firstAnswerButton: UIButton!
    @IBOutlet weak var secondAnswerButton: UIButton!
    @IBOutlet weak var thirdAnswerButton: UIButton!
    @IBOutlet weak var fourthAnswerButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    // UIButtons Lightning Mode
    @IBOutlet weak var normalModeButton: UIButton!
    @IBOutlet weak var lightningModeButton: UIButton!
    
    // When the view is loaded, fire up the welcome sound and start playing the quiz game
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sound
        loadGameStartSound()
        playGameStartSound()
        // Start game
        //displayQuestion()
        gameStart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gameStart() {
        // Hide of the unecessary labels
        playAgainButton.isHidden = true
        answerFeedback.isHidden = true
        answer.isHidden = true
        
        questionField.isHidden = true
        
        firstAnswerButton.isHidden = true
        secondAnswerButton.isHidden = true
        thirdAnswerButton.isHidden = true
        fourthAnswerButton.isHidden = true
        questionField.isHidden = true
    }
    
    func displayQuestion() {
        // Choose and display question
        quiz.indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: quiz.questions.count)
        let questionDictionary = quiz.questions[quiz.indexOfSelectedQuestion]
        questionField.text = questionDictionary.question
        
        // Add the label for the possible answer
        firstAnswerButton.setTitle(questionDictionary.answers[0].answer, for: .normal)
        secondAnswerButton.setTitle(questionDictionary.answers[1].answer, for: .normal)
        thirdAnswerButton.setTitle(questionDictionary.answers[2].answer, for: .normal)
        fourthAnswerButton.setTitle(questionDictionary.answers[3].answer, for: .normal)
        
        // Hide of the unecessary labels
        playAgainButton.isHidden = true
        answerFeedback.isHidden = true
        answer.isHidden = true
        
        normalModeButton.isHidden = true
        lightningModeButton.isHidden = true
    }
    
    func displayScore() {
        // Hide all answer buttons
        firstAnswerButton.isHidden = true
        secondAnswerButton.isHidden = true
        thirdAnswerButton.isHidden = true
        fourthAnswerButton.isHidden = true
        
        // Hide the feedback
        answerFeedback.isHidden = true
        
        // Display play again button and the game feedbacks
        playAgainButton.isHidden = false
        questionField.text = "Way to go!\nYou got \(quiz.correctQuestions) out of \(quiz.questionsPerRound) correct!"
    }
    
    func nextRound() {
        if quiz.questionsAsked == quiz.questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Stock the selected question
        let selectedQuestion: Question = quiz.questions[quiz.indexOfSelectedQuestion]
        
        // And then review the answer
        if (quiz.isAnswerCorrect(question: selectedQuestion, choosenAnswer: sender.titleLabel?.text ?? "")) {
            // Here this is true
            quiz.correctQuestions += 1
            answerFeedback.textColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0)
            answerFeedback.text = "Correct!"
            AudioServicesPlaySystemSound(winningSystemSoundID)
        } else {
            // Here this is false
            answerFeedback.textColor = UIColor(red: 230/255.0, green: 126/255.0, blue: 34/255.0, alpha: 1.0)
            answerFeedback.text = "Sorry, that's not it."
            answer.isHidden = false
            answer.text = "This answer was: \(quiz.selectCorrectAnswer(question: selectedQuestion))"
            AudioServicesPlaySystemSound(losingSystemSoundID)
        }
        
        // Increment the number of questions asked and remove the question from the array
        quiz.questionsAsked += 1
        quiz.questions.remove(at: quiz.indexOfSelectedQuestion)
        
        // show the true/false feedback
        answerFeedback.isHidden = false
        loadNextRoundWithDelay(seconds: 2)
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        firstAnswerButton.isHidden = false
        secondAnswerButton.isHidden = false
        thirdAnswerButton.isHidden = false
        fourthAnswerButton.isHidden = false
        
        // Initiliaze the array of questions
        quiz.questions = [firstQuestion, secondQuestion, thirdQuestion, fourthQuestion, fifthQuestion, sixthQuestion, seventhQuestion, eighthQuestion, ninthQuestion, tenthQuestion]
        // And the incremental variables
        quiz.questionsAsked = 0
        quiz.correctQuestions = 0
        nextRound()
    }

    // MARK: Helper Methods
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

