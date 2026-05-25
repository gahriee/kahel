import UIKit
import Combine

class LeaderboardViewController: UIViewController {
    private let viewModel = LeaderboardViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.bg(for: traitCollection)
        title = "Leaderboard"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        viewModel.watch()
        
        viewModel.$entries.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
}

extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let entry = viewModel.entries[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = AppColors.text(for: traitCollection)
        cell.textLabel?.text = "#\(indexPath.row + 1) - \(entry.username) (Lvl \(entry.level))"
        return cell
    }
}
