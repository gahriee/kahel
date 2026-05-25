import UIKit
import Combine

class SavingsViewController: UIViewController {
    private let viewModel = SavingsViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()
    private let totalLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let user = AuthService.shared.currentUser {
            viewModel.watch(uid: user.uid)
        }
        
        viewModel.$banks.sink { [weak self] banks in
            self?.tableView.reloadData()
            let total = banks.reduce(0) { $0 + $1.balance }
            self?.totalLabel.text = "TOTAL SAVED: $\(String(format: "%.2f", total))"
        }.store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.bg(for: traitCollection)
        title = "Vault"
        
        totalLabel.font = AppFonts.pixel(size: 14)
        totalLabel.textColor = AppColors.gold
        totalLabel.textAlignment = .center
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(totalLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "bankCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension SavingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.banks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "bankCell")
        let bank = viewModel.banks[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.font = AppFonts.pixel(size: 10)
        cell.textLabel?.textColor = AppColors.text(for: traitCollection)
        cell.textLabel?.text = bank.bankName
        
        cell.detailTextLabel?.font = AppFonts.body(size: 14)
        cell.detailTextLabel?.textColor = AppColors.textDim(for: traitCollection)
        
        let displayBalance = viewModel.isHidden ? "****" : "$\(String(format: "%.2f", bank.balance))"
        cell.detailTextLabel?.text = "Balance: \(displayBalance) | Goal: $\(String(format: "%.2f", bank.savingsGoal))"
        
        return cell
    }
}
