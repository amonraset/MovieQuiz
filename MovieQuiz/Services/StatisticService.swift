
//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by sm on 23.09.2024.
//

import Foundation


final class StatisticService: StatisticServiceProtocol {
    
    private enum Keys: String {
        case correctAnswers
        case bestGame
        case gamesCount
        
        enum BestGame: String {
            case correct
            case total
            case date
        }
    }
        
    private let storage: UserDefaults = .standard
    

    var gamesCount: Int {
        get{
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get{
            let correct = storage.integer(forKey: Keys.BestGame.correct.rawValue)   // тут была ошибка
            let total = storage.integer(forKey: Keys.BestGame.total.rawValue)       // тут была ошибка
            let date = storage.object(forKey: Keys.BestGame.date.rawValue) as? Date ?? Date()   // тут былв ошибка
            let best = GameResult(correct: correct, total: total, date: date)
            return best
        }
        set {
            storage.set(newValue.correct, forKey: Keys.BestGame.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.BestGame.total.rawValue)
            storage.set(newValue.date, forKey: Keys.BestGame.date.rawValue)
        }
    }
    
    private var correctAnswers: Int {
        get{
            storage.integer(forKey: Keys.correctAnswers.rawValue)   // тут былв ошибка в correctAnswers
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue) // тут былв ошибка в correctAnswers
        }
    }
    
    var totalAccuracy: Double {
      
        if gamesCount != 0 && correctAnswers != 0 {
            return  (Double(correctAnswers)/(Double(bestGame.total * gamesCount))) * 100
        }
        else {return 0}
        
    }
    
    func store(correct count: Int, total amount: Int) {
        print ("статистика и ГДЕ она?")
        correctAnswers += count
        gamesCount += 1
        let newGame = GameResult(correct: count, total: amount, date: Date())
        if newGame.isBetterThan(bestGame) || newGame.isEqual(another: bestGame) {
        bestGame = newGame
        }
    }
}






