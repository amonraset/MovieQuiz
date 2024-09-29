
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
    func isEqual(another: GameResult) -> Bool {
            correct == another.correct
        }
}


