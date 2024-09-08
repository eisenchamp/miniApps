import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    let toggleButton = UIButton(type: .system)
    private var isExpanded = false
    private var miniApps: [MiniApp] = [
        MiniApp(name: "Weather",
                view: WeatherMiniAppView(),
                viewController: WeatherViewController()),

        MiniApp(name: "City Info",
                view: CityInfoMiniAppView(),
                viewController: CityInfoViewController()),

        MiniApp(name: "Crossword",
                view: CrosswordMiniAppView(),
                viewController: CrosswordViewController()),

        MiniApp(name: "Tic-Tac-Toe",
                view: TicTacToeMiniAppView(),
                viewController: TicTacToeViewController())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupToggleButton()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: toggleButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(MiniAppCell.self, forCellReuseIdentifier: "MiniAppCell")
    }
    
    private func setupToggleButton() {
        toggleButton.setTitle("Change The View", for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleView), for: .touchUpInside)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.layer.borderWidth = 3.0
        toggleButton.layer.borderColor = UIColor.darkGray.cgColor
        toggleButton.setTitleColor(.darkGray, for: .normal)
        
        view.addSubview(toggleButton)
        
        NSLayoutConstraint.activate([
            toggleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            toggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toggleButton.widthAnchor.constraint(equalToConstant: 200),
            toggleButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        view.bringSubviewToFront(toggleButton)
    }

    
    @objc private func toggleView() {
        isExpanded.toggle()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return miniApps.count * 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiniAppCell", for: indexPath) as! MiniAppCell
        let miniApp = miniApps[indexPath.row % miniApps.count]
        cell.configure(with: miniApp, isExpanded: isExpanded)
        cell.buttonAction = { [weak self] in
            self?.openMiniAppViewController(for: miniApp)
        }
        return cell
    }
    
    private func openMiniAppViewController(for miniApp: MiniApp) {
        let viewController = miniApp.viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isExpanded ? view.frame.height / 2 : view.frame.height / 8
    }
}
