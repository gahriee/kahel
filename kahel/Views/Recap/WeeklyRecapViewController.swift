import UIKit
import Combine

class WeeklyRecapViewController: UIViewController {
    private let viewModel = RecapViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let summaryLabel = UILabel()
    private let flavorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let user = AuthService.shared.currentUser {
            viewModel.watch(uid: user.uid)
        }
        
        viewModel.$weekTotal.combineLatest(viewModel.$topCategory, viewModel.$flavorText, viewModel.$logCount)
            .sink { [weak self] total, category, flavor, count in
                guard let self = self else { return }
                self.summaryLabel.text = """
                7-DAY RECAP
                
                Total Spent: $\(String(format: "%.2f", total))
                Transactions: \(count)
                Top Category: \(category)
                """
                self.flavorLabel.text = flavor
            }.store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.bg(for: traitCollection)
        title = "Weekly Recap"
        
        summaryLabel.font = AppFonts.pixel(size: 12)
        summaryLabel.textColor = AppColors.text(for: traitCollection)
        summaryLabel.numberOfLines = 0
        summaryLabel.textAlignment = .center
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryLabel)
        
        flavorLabel.font = AppFonts.body(size: 16, weight: .medium)
        flavorLabel.textColor = AppColors.accent
        flavorLabel.textAlignment = .center
        flavorLabel.numberOfLines = 0
        flavorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flavorLabel)
        
        NSLayoutConstraint.activate([
            summaryLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            flavorLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 40),
            flavorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            flavorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
