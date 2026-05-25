import UIKit
import Combine

class LogsViewController: UIViewController {
    private let viewModel = LogsViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let user = AuthService.shared.currentUser {
            Task {
                await viewModel.loadFirstPage(uid: user.uid)
            }
        }
        
        viewModel.$items.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.bg(for: traitCollection)
        title = "Expense Logs"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "logCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension LogsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "logCell")
        let expense = viewModel.items[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.textLabel?.font = AppFonts.body(size: 16, weight: .bold)
        cell.textLabel?.textColor = AppColors.text(for: traitCollection)
        cell.textLabel?.text = "\(expense.category) - $\(String(format: "%.2f", expense.amount))"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        cell.detailTextLabel?.font = AppFonts.body(size: 12)
        cell.detailTextLabel?.textColor = AppColors.textDim(for: traitCollection)
        cell.detailTextLabel?.text = "\(expense.note) • \(formatter.string(from: expense.createdAt))"
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if position > contentHeight - scrollView.frame.size.height * 2 {
            if let user = AuthService.shared.currentUser {
                Task {
                    await viewModel.loadMore(uid: user.uid)
                }
            }
        }
    }
}
