import UIKit

class CrosswordViewController: UIViewController {

    let gridSize = 5
    var crosswordGrid: [[UITextField]] = []
    let answers: [[String]] = [
        ["H", "E", "L", "L", "O"],
        ["E", "X", "", "I", "A"],
        ["L", "T", "", "M", "T"],
        ["L", "R", "", "E", "S"],
        ["O", "A", "T", "S", ""]
    ]

    let acrossClues = ["1. Greeting", "2. Last partner", "5. Breakfast"]
    let downClues = ["1. Opposite of goodbye", "2. One more", "4. Green lemons", "5. Morning grain"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupUI()
        setupCrosswordGrid()
        setupClues()
    }

    func setupUI() {
        let label = UILabel()
        label.text = "Crossword App"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    func setupCrosswordGrid() {
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 5
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridStackView)

        NSLayoutConstraint.activate([
            gridStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        for row in 0..<gridSize {
            var rowArray: [UITextField] = []
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 5

            for col in 0..<gridSize {
                let textField = createGridTextField(row: row, col: col)
                rowArray.append(textField)
                rowStackView.addArrangedSubview(textField)
            }

            crosswordGrid.append(rowArray)
            gridStackView.addArrangedSubview(rowStackView)
        }
    }

    func createGridTextField(row: Int, col: Int) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.widthAnchor.constraint(equalToConstant: 40).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.autocapitalizationType = .allCharacters
        textField.isUserInteractionEnabled = answers[row][col] != ""  // Only allow input in active cells
        textField.tag = row * gridSize + col  // Unique tag to identify the cell
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }

    func setupClues() {
        let acrossLabel = UILabel()
        acrossLabel.text = "Across:"
        acrossLabel.textColor = .white
        acrossLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        acrossLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(acrossLabel)
        
        NSLayoutConstraint.activate([
            acrossLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            acrossLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])

        for (index, clue) in acrossClues.enumerated() {
            let clueLabel = UILabel()
            clueLabel.text = clue
            clueLabel.textColor = .white
            clueLabel.font = UIFont.systemFont(ofSize: 16)
            clueLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(clueLabel)
            
            NSLayoutConstraint.activate([
                clueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                clueLabel.topAnchor.constraint(equalTo: acrossLabel.bottomAnchor, constant: CGFloat(20 * (index + 1)))
            ])
        }

        let downLabel = UILabel()
        downLabel.text = "Down:"
        downLabel.textColor = .white
        downLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        downLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(downLabel)
        
        NSLayoutConstraint.activate([
            downLabel.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180),
            downLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])

        for (index, clue) in downClues.enumerated() {
            let clueLabel = UILabel()
            clueLabel.text = clue
            clueLabel.textColor = .white
            clueLabel.font = UIFont.systemFont(ofSize: 16)
            clueLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(clueLabel)
            
            NSLayoutConstraint.activate([
                clueLabel.leadingAnchor.constraint(equalTo: downLabel.leadingAnchor),
                clueLabel.topAnchor.constraint(equalTo: downLabel.bottomAnchor, constant: CGFloat(20 * (index + 1)))
            ])
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let row = textField.tag / gridSize
        let col = textField.tag % gridSize

        if textField.text?.uppercased() == answers[row][col] {
            textField.textColor = .green
        } else {
            textField.textColor = .red
        }

        checkForCompletion()
    }

    func checkForCompletion() {
        var isComplete = true
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if crosswordGrid[row][col].isUserInteractionEnabled,
                   crosswordGrid[row][col].text?.uppercased() != answers[row][col] {
                    isComplete = false
                    break
                }
            }
        }

        if isComplete {
            displayCompletionMessage()
        }
    }

    func displayCompletionMessage() {
        let alert = UIAlertController(title: "Congratulations!", message: "You have completed the crossword!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.resetCrossword()
        }))
        present(alert, animated: true)
    }

    func resetCrossword() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                crosswordGrid[row][col].text = ""
                crosswordGrid[row][col].textColor = .black
            }
        }
    }
}
