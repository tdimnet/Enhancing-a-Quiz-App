//
//  QuizController.swift
//  TrueFalseStarter
//
//  Created by Thomas Dimnet on 19/04/2018.
//  Copyright © 2018 Treehouse. All rights reserved.
//

class Quiz {
    let questions: [Question]
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
}
