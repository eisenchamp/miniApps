import UIKit

class TicTacToeMiniAppView: UIView {

    enum Player {
        case none, human, computer
    }

    var board: [Player] = Array(repeating: .none, count: 9)
    let winningCombinations = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]
    ]
    var currentPlayer: Player = .human
    var buttons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .lightGray
        
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 10
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gridStackView)
        
        NSLayoutConstraint.activate([
            gridStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridStackView.topAnchor.constraint(equalTo: topAnchor),
            gridStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for row in 0..<3 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            
            for col in 0..<3 {
                let button = createButton(tag: row * 3 + col)
                buttons.append(button)
                rowStackView.addArrangedSubview(button)
            }
            
            gridStackView.addArrangedSubview(rowStackView)
        }
    }

    private func createButton(tag: Int) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        button.tag = tag
        button.addTarget(self, action: #selector(cellTapped(_:)), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return button
    }

    @objc private func cellTapped(_ sender: UIButton) {
        let index = sender.tag
        if board[index] == .none {
            board[index] = .human
            sender.setTitle("X", for: .normal)
            if checkForWinner() == .none && !boardIsFull() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.computerTurn()
                }
            }
        }
    }

    private func computerTurn() {
        let bestMove = findBestMove()
        board[bestMove] = .computer
        buttons[bestMove].setTitle("O", for: .normal)
        if checkForWinner() == .none && !boardIsFull() {
            currentPlayer = .human
        }
    }

    private func checkForWinner() -> Player {
        for combination in winningCombinations {
            let (a, b, c) = (board[combination[0]], board[combination[1]], board[combination[2]])
            if a != .none && a == b && b == c {
                displayWinner(a == .human ? "You Win!" : "Computer Wins!")
                return a
            }
        }
        if boardIsFull() {
            displayWinner("It's a Draw!")
        }
        return .none
    }

    private func boardIsFull() -> Bool {
        return !board.contains(.none)
    }

    private func displayWinner(_ message: String) {
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.resetBoard()
        }))
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }

    private func resetBoard() {
        board = Array(repeating: .none, count: 9)
        for button in buttons {
            button.setTitle("", for: .normal)
        }
    }

    private func findBestMove() -> Int {
        var bestMove = -1
        var bestScore = Int.min
        
        for i in 0..<board.count {
            if board[i] == .none {
                board[i] = .computer
                let score = minimax(depth: 0, isMaximizing: false)
                board[i] = .none
                if score > bestScore {
                    bestScore = score
                    bestMove = i
                }
            }
        }
        return bestMove
    }

    private func evaluateBoard() -> Int {
        for combination in winningCombinations {
            let (a, b, c) = (board[combination[0]], board[combination[1]], board[combination[2]])
            if a != .none && a == b && b == c {
                return a == .computer ? 10 : -10
            }
        }
        return 0
    }

    private func minimax(depth: Int, isMaximizing: Bool) -> Int {
        let score = evaluateBoard()
        if score == 10 { return score }
        if score == -10 { return score }
        if boardIsFull() { return 0 }

        if isMaximizing {
            var bestScore = Int.min
            for i in 0..<board.count {
                if board[i] == .none {
                    board[i] = .computer
                    let score = minimax(depth: depth + 1, isMaximizing: false)
                    board[i] = .none
                    bestScore = max(score, bestScore)
                }
            }
            return bestScore
        } else {
            var bestScore = Int.max
            for i in 0..<board.count {
                if board[i] == .none {
                    board[i] = .human
                    let score = minimax(depth: depth + 1, isMaximizing: true)
                    board[i] = .none
                    bestScore = min(score, bestScore)
                }
            }
            return bestScore
        }
    }
}
