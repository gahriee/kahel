import UIKit

class AddExpenseViewController: UIViewController {
    
    // In a full implementation, we'd have a ViewModel for this sheet.
    // We are simulating the core fields for the migration phase.
    
    private let titleLabel = UILabel()
    private let amountField = PixelTextField()
    private let categorySegment = UISegmentedControl(items: ["Food", "Transport", "Shopping", "Other"])
    private let submitButton = PixelButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.surface(for: traitCollection)
        
        titleLabel.text = "LOG EXPENSE"
        titleLabel.font = AppFonts.pixel(size: 16)
        titleLabel.textColor = AppColors.accent
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        amountField.title = "AMOUNT"
        amountField.textField.keyboardType = .decimalPad
        amountField.translatesAutoresizingMaskIntoConstraints = false
        
        categorySegment.selectedSegmentIndex = 0
        categorySegment.translatesAutoresizingMaskIntoConstraints = false
        
        submitButton.title = "SUBMIT"
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, amountField, categorySegment, submitButton])
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func handleSubmit() {
        // This is where we'd call FirestoreService.shared.logExpense
        // For now, we simulate success and dismiss.
        PixelToast.show(message: "Expense Logged! XP +10", success: true)
        dismiss(animated: true)
    }
}
