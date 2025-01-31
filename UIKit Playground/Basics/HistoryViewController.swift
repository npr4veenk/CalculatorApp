import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var history: [[String: Any]] {
            get { return CalculatorViewController.history }
        }
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .insetGrouped)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = .darkHBack
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        view.backgroundColor = .darkHBack
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.separatorColor = .black
        
        navigationItem.titleView = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = .white
            label.alpha = 0.5
            label.text = "History"
            label.font = CalculatorViewController.zohoPuviFont
            label.translatesAutoresizingMaskIntoConstraints = false
            label.layer.masksToBounds = true
            return label
        }()
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = history[indexPath.row]
//        print(item)
    
        guard let result = item["Result"] as? String,
              let expression = item["Expression"] as? String else {
            cell.textLabel?.text = "Unknown Result"
            cell.detailTextLabel?.text = nil
            cell.accessoryView = nil
            return cell
        }
        cell.textLabel?.text = result
        cell.textLabel?.font = .systemFont(ofSize: 26, weight: .bold)
        cell.detailTextLabel?.text = expression

        let arrowButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "arrow.uturn.left"), for: .normal)
            button.tintColor = .darkArrowTint
//            button.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            button.tag = indexPath.row
            button.addTarget(self, action: #selector(redirectToCalculatorViewController), for: .touchUpInside)
            return button
        }()
        
        let deleteButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "trash"), for: .normal)
            button.tintColor = .red
//            button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            button.tag = indexPath.row
            button.addTarget(self, action: #selector(displayDeletionAlert), for: .touchUpInside)
            return button
        }()
        
        let buttonStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [arrowButton, deleteButton])
            stackView.axis = .horizontal
            stackView.frame = CGRect(x: 0, y: 0, width: 95, height: 30)
            return stackView
        }()

        
        cell.accessoryView = buttonStackView
        
        cell.textLabel?.textColor = .darkText
        cell.detailTextLabel?.textColor = .darkText
        cell.backgroundColor = .darkPurple
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .darkBack
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Tapped row \(indexPath.row)")
//        if let cell = tableView.cellForRow(at: indexPath){
//            
//            UIView.animate(withDuration: 1, delay: 0, options: []) {
//                cell.backgroundColor = .black
//            }
//            cell.backgroundColor = .darkPurple
//        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print("Hello")
        if let cell = tableView.cellForRow(at: indexPath){
            UIView.animate(withDuration: 1, delay: 0, options: []) {
                cell.backgroundColor = .darkText
            }
            cell.backgroundColor = .darkPurple
        }
    }
    
    private func redirectToCalculatorVC(tag: Int) {
        let item = history[tag]
            
        guard let result = item["Result"] as? String,
                let expression = item["Expression"] as? String else { return }
            
        if let calculatorVC = navigationController?.viewControllers.first as? CalculatorViewController {
            calculatorVC.result = result
            calculatorVC.expression = expression
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    
    @objc private func displayDeletionAlert(_ sender: UIButton) {
        let deletionAlert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        let cancelAlertButton = UIAlertAction(title: "Cancel", style: .cancel) {_ in
        }
        let deleteAlertButton = UIAlertAction(title: "Delete", style: .destructive) {_ in
            self.deleteHistoryItem(tag: sender.tag)
        }
        
        deletionAlert.addAction(cancelAlertButton)
        deletionAlert.addAction(deleteAlertButton)
        
        present(deletionAlert, animated: true)
    }
    
    func deleteHistoryItem(tag: Int){
        CalculatorViewController.history.remove(at: tag)
        tableView.reloadData()
    }
    
    @objc private func redirectToCalculatorViewController(_ sender: UIButton) {
            redirectToCalculatorVC(tag: sender.tag)
        }
}

extension UIColor {
    static let darkHBack = UIColor(red: 0.22, green: 0.17, blue: 0.29, alpha: 1.0) // Slightly deeper, smooth dark background

    static let darkText = UIColor(red: 0.90, green: 0.88, blue: 0.92, alpha: 1.0) // Softer white for text
    static let darkPurple = UIColor(red: 0.29, green: 0.19, blue: 0.38, alpha: 1.0) // Deep purple for backgrounds
    static let darkArrowTint = UIColor(red: 0.70, green: 0.60, blue: 0.85, alpha: 1.0) // Slightly muted white for icons
}


#Preview {
    HistoryViewController()
}
