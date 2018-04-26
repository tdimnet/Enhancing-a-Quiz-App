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

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    var gameSound: SystemSoundID = 0
    
    var quiz = Quiz(
        questions: [firstQuestion, secondQuestion, thirdQuestion, fourthQuestion, fifthQuestion, sixthQuestion, seventhQuestion, eighthQuestion, ninthQuestion, tenthQuestion],
        questionsPerRound: 4,
        questionsAsked: 0,
        correctQuestions: 0
    )
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerFeedback: UILabel!
    
    @IBOutlet weak var firstAnswerButton: UIButton!
    @IBOutlet weak var secondAnswerButton: UIButton!
    @IBOutlet weak var thirdAnswerButton: UIButton!
    @IBOutlet weak var fourthAnswerButton: UIButton!
    
    @IBOutlet weak var playAgainButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        //playGameStartSound() -> For now hide the sound on start
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        // Choose and display the question itself
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: quiz.questions.count)
        let questionDictionary = quiz.questions[indexOfSelectedQuestion]
        questionField.text = questionDictionary.question
        
        firstAnswerButton.setTitle(questionDictionary.answers[0].answer, for: .normal)
        secondAnswerButton.setTitle(questionDictionary.answers[1].answer, for: .normal)
        thirdAnswerButton.setTitle(questionDictionary.answers[2].answer, for: .normal)
        fourthAnswerButton.setTitle(questionDictionary.answers[3].answer, for: .normal)
        
        playAgainButton.isHidden = true
        answerFeedback.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        firstAnswerButton.isHidden = true
        secondAnswerButton.isHidden = true
        thirdAnswerButton.isHidden = true
        fourthAnswerButton.isHidden = true
        
        answerFeedback.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
    
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        questionsAsked += 1
        answerFeedback.isHidden = false
        
        let selectedQuestion = quiz.questions[indexOfSelectedQuestion]
        
        if (sender.titleLabel?.text ?? "" == selectedQuestion.answers[0].answer && selectedQuestion.answers[0].isCorrect == true) {
            correctQuestions += 1
            answerFeedback.textColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0)
            answerFeedback.text = "Correct!"
        } else if (sender.titleLabel?.text ?? "" == selectedQuestion.answers[1].answer && selectedQuestion.answers[1].isCorrect == true) {
            correctQuestions += 1
            answerFeedback.textColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0)
            answerFeedback.text = "Correct!"
        } else if (sender.titleLabel?.text ?? "" == selectedQuestion.answers[2].answer && selectedQuestion.answers[2].isCorrect == true) {
            correctQuestions += 1
            answerFeedback.textColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0)
            answerFeedback.text = "Correct!"
        } else if (sender.titleLabel?.text ?? "" == selectedQuestion.answers[3].answer && selectedQuestion.answers[3].isCorrect == true) {
            correctQuestions += 1
            answerFeedback.textColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0)
            answerFeedback.text = "Correct!"
        } else {
            answerFeedback.textColor = UIColor(red: 230/255.0, green: 126/255.0, blue: 34/255.0, alpha: 1.0)
            answerFeedback.text = "Sorry, that's not it."
        }
        
        quiz.questions.remove(at: indexOfSelectedQuestion)
        
        print(quiz.questions.count)
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        firstAnswerButton.isHidden = false
        secondAnswerButton.isHidden = false
        thirdAnswerButton.isHidden = false
        fourthAnswerButton.isHidden = false
        
        quiz.questions = [firstQuestion, secondQuestion, thirdQuestion, fourthQuestion, fifthQuestion, sixthQuestion, seventhQuestion, eighthQuestion, ninthQuestion, tenthQuestion]
        
        questionsAsked = 0
        correctQuestions = 0
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

