import Marko

struct Game {
    
    static let empty = Block(width: 3, height: 3, repeatedValue: GameCell.Empty)
    
    enum GameCell: Printable {
        case Nought
        case Cross
        case Empty
        
        var description: String {
            switch self {
            case .Nought: return "O"
            case .Cross: return "X"
            default: return "·"
            }
        }
    }
    
    private static var currentPlayer: GameCell = arc4random_uniform(2) == 1 ? .Cross : .Nought
    
    private var states = [Game.empty]
    
    var state: Block<GameCell> { return states.last! }
    
    private static var coordinatesUsed: [(Int, Int)] = [(0, 0)]
        
    mutating func play(row: Int, _ col: Int) {
        if playerWon() { fatalError("Game is finished") }
        var newState = state
        newState[row, col] = Game.currentPlayer
        Game.coordinatesUsed.append(row, col)
        states.append(newState)
    }
    
    private func isEmpty() -> Bool {
        var bools: [Bool] = []
        for a in state.rows {
            bools.append(a.filter({ $0 != .Empty }).isEmpty)
        }
        return bools.filter{ $0 != true }.isEmpty
    }
    
    private func playerWon() -> Bool {
        for a in [state.leftDiagonal, state.rightDiagonal, state.row(Game.coordinatesUsed.last!.0), state.col(Game.coordinatesUsed.last!.1)] {
            if a.filter({ $0 != Game.currentPlayer }).isEmpty { return true }
        }
        if !isEmpty() {
            Game.currentPlayer = Game.currentPlayer == .Nought ? .Cross : .Nought
        }
        return false
    }
    
    private var playerWonMessage: String { return playerWon() ? "Player won!" : "" }
    private var welcomeMessage: String = "Welcome to noughts and crosses!"
    
}

extension Game: Printable {
    var description: String {
        var a: [String] = []
        for (i, state) in enumerate(states) {
            a.append("\nmove \(i): \n\(state)")
        }
        return welcomeMessage + "\n" + "\n".join(a) + "\n" + "\n" + playerWonMessage
    }
}


var game = Game()

game.play(1, 1)
game.play(2, 2)
game.play(2, 0)
game.play(0, 1)
game.play(0, 2)

println(game)






































