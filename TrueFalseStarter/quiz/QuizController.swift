//
//  QuizController.swift
//  TrueFalseStarter
//
//  Created by Thomas Dimnet on 19/04/2018.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import GameKit

class Quiz {
    var questions: [Question]
    let questionsPerRound: Int
    var questionsAsked: Int
    var correctQuestions: Int
    var indexOfSelectedQuestion: Int
    
    init(questions: [Question], questionsPerRound: Int, questionsAsked: Int, correctQuestions: Int, indexOfSelectedQuestion: Int) {
        self.questions = questions
        self.questionsPerRound = questionsPerRound
        self.questionsAsked = questionsAsked
        self.correctQuestions = correctQuestions
        self.indexOfSelectedQuestion = indexOfSelectedQuestion
    }
    
    func selectQuestionRandomly() -> Question {
        let randomIndex: Int = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        return questions[randomIndex]
    }
    
    func isAnswerCorrect(question: Question, choosenAnswer: String) -> Bool {
        for index in 0..<question.answers.count {
            if (question.answers[index].isCorrect && question.answers[index].answer == choosenAnswer) {
                return true
            }
        }
        return false
    }
}
