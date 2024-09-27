//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by sm on 19.09.2024.
//
import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
