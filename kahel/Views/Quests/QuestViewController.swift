import UIKit
import Combine

class QuestViewController: UIViewController {
    private let viewModel = QuestViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let user = AuthService.shared.currentUser {
            viewModel.watch(uid: user.uid)
        }
        
        viewModel.$dailyQuest.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.bg(for: traitCollection)
        title = "Daily Quests"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "questCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension QuestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyQuest?.quests.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "questCell")
        guard let quest = viewModel.dailyQuest?.quests[indexPath.row] else { return cell }
        
        cell.backgroundColor = .clear
        cell.textLabel?.font = AppFonts.pixel(size: 8)
        cell.textLabel?.textColor = quest.completed ? AppColors.success : AppColors.text(for: traitCollection)
        cell.textLabel?.text = quest.label
        
        cell.detailTextLabel?.font = AppFonts.body(size: 12)
        cell.detailTextLabel?.textColor = AppColors.textDim(for: traitCollection)
        cell.detailTextLabel?.text = "Progress: \(quest.progress)/\(quest.target)  |  Reward: \(quest.xpReward) XP"
        
        if quest.completed {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
