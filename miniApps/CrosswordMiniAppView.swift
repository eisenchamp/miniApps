import UIKit

class CrosswordMiniAppView: UIView {
    
    let gridSize = 5
    var crosswordGrid: [[UITextField]] = []
    let answers: [[String]] = [
        ["H", "E", "L", "L", "O"],
        ["E", "X", "", "I", "A"],
        ["L", "T", "", "M", "T"],
        ["L", "R", "", "E", "S"],
        ["O", "A", "T", "S", ""]
    ]
    
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
        setupCrosswordGrid()
    }
    
    private func setupCrosswordGrid() {
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 5
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gridStackView)
        
        NSLayoutConstraint.activate([
            gridStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridStackView.topAnchor.constraint(equalTo: topAnchor),
            gridStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
    
    private func createGridTextField(row: Int, col: Int) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.widthAnchor.constraint(equalToConstant: 40).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.autocapitalizationType = .allCharacters
        textField.isUserInteractionEnabled = answers[row][col] != ""
        textField.tag = row * gridSize + col
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let row = textField.tag / gridSize
        let col = textField.tag % gridSize
        
        if textField.text?.uppercased() == answers[row][col] {
            textField.textColor = .green
        } else {
            textField.textColor = .red
        }
    }
}
