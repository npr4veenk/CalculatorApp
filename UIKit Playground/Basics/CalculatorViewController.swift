import UIKit
import LocalAuthentication


class CalculatorViewController: UIViewController {
    static var buttonWidth = 0
    static var buttonHeight = 0
    static var theme = true
    //true - dark  //false - light
    
    var expression: String = "" {
        didSet{
            updateMainLabel()
        }
    }
    var result: String = "" {
        didSet{
            updateResultLabel()
        }
    }
    
    static let zohoPuviFont = UIFont(name: "ZohoPuvi-Medium", size: 20)
    
    
    static var history: [[String: Any]] = [
        ["Result": "420", "Expression": "400+20"],
        ["Result": "1000", "Expression": "500*2"],
        ["Result": "200", "Expression": "1000-800"],
        ["Result": "100", "Expression": "200/2"],
        ["Result": "300", "Expression": "100+200"],
        ["Result": "500", "Expression": "250*2"],
        ["Result": "350", "Expression": "100+250"],
        ["Result": "150", "Expression": "200-50"],
    ]
    
    private lazy var deleteButton = createSymbolButton(symbol: "delete.left", backgroundColor: .darkBack, fontColor: .symbolPurple)
    private lazy var clearButton = createSymbolButton(symbol: "trash", backgroundColor: .darkBack, fontColor: .symbolPurple)
    private lazy var dotButton = createValueButton(value: ".", backgroundColor: .darkBack, fontColor: .symbolPurple, fontSize: 27)
    private lazy var divideButton = createValueButton(value: "/", backgroundColor: .darkButtonPurple, fontColor: .symbolPurple, fontSize: 35)

    private lazy var button7 = createValueButton(value: "7", backgroundColor: .darkBack, fontColor: .white)
//    private lazy var button7 = createValueButton(value: "7", backgroundColor: .darkBack, fontColor: .white)
    private lazy var button8 = createValueButton(value: "8", backgroundColor: .darkBack, fontColor: .white)
    private lazy var button9 = createValueButton(value: "9", backgroundColor: .darkBack, fontColor: .white)
    private lazy var multiplyButton = createValueButton(value: "*", backgroundColor: .darkButtonPurple, fontColor: .symbolPurple, fontSize: 30)

    private lazy var button4 = createValueButton(value: "4", backgroundColor: .darkBack, fontColor: .white)
    private lazy var button5 = createValueButton(value: "5", backgroundColor: .darkBack, fontColor: .white)
    private lazy var button6 = createValueButton(value: "6", backgroundColor: .darkBack, fontColor: .white)
    private lazy var minusButton = createValueButton(value: "-", backgroundColor: .darkButtonPurple, fontColor: .symbolPurple, fontSize: 40)

    private lazy var button1 = createValueButton(value: "1", backgroundColor: .darkBack, fontColor: .white)
    private lazy var button2 = createValueButton(value: "2", backgroundColor: .darkBack, fontColor: .white)
    private lazy var button3 = createValueButton(value: "3", backgroundColor: .darkBack, fontColor: .white)
    private lazy var plusButton = createValueButton(value: "+", backgroundColor: .darkButtonPurple, fontColor: .symbolPurple, fontSize: 30)

    private lazy var openBracketsButton = createValueButton(value: "(", backgroundColor: .darkBack, fontColor: .symbolPurple, fontSize: 27)
    private lazy var button0 = createValueButton(value: "0", backgroundColor: .darkBack, fontColor: .white)
    private lazy var closeBracketsButton = createValueButton(value: ")", backgroundColor: .darkBack, fontColor: .symbolPurple, fontSize: 35)
    private lazy var equalsButton = createSymbolButton(symbol: "equal", backgroundColor: .darkEqualsPurple, fontColor: .white)
    
    private lazy var logo: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.alpha = 0.5
        label.font = CalculatorViewController.zohoPuviFont
        label.text = "Calculator"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 75)
        label.font = UIFont(name: "ZohoPuvi-Medium", size: 75)
        label.textColor = .white
        label.textAlignment = .right
        label.text = "0"
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 35)
        label.font = UIFont(name: "ZohoPuvi-Medium", size: 35)

        label.textColor = .symbolPurple
        label.textAlignment = .right
        label.text = "0"
        label.layer.masksToBounds = true
        return label
    }()

    private lazy var subStack1 = createSubStackViews(array: [deleteButton, clearButton, dotButton, divideButton])
    private lazy var subStack2 = createSubStackViews(array: [button7, button8, button9, multiplyButton])
    private lazy var subStack3 = createSubStackViews(array: [button4, button5, button6, minusButton])
    private lazy var subStack4 = createSubStackViews(array: [button1, button2, button3, plusButton])
    private lazy var subStack5 = createSubStackViews(array: [openBracketsButton, button0, closeBracketsButton, equalsButton])
    
    
    private lazy var mainStackView2: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:[subStack1, subStack2, subStack3, subStack4, subStack5])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView()])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bodyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainLabel, resultLabel, UIView()])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        return stackView
    }()
    
    private lazy var mainStackView1: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerStackView,bodyStackView])
        stackView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for familyName in UIFont.familyNames {
////            print("Family: \(familyName)")
//            for fontName in UIFont.fontNames(forFamilyName: familyName) {
////                print("Font: \(fontName)")
//            }
//        }
        
        CalculatorViewController.buttonWidth = Int(view.frame.width) / 4
        CalculatorViewController.buttonHeight = Int(view.frame.height) / 11
        
        view.backgroundColor = .darkBack
        view.addSubview(mainStackView1)
        view.addSubview(mainStackView2)
        
        NSLayoutConstraint.activate([
            mainStackView1.topAnchor.constraint(equalTo: view.topAnchor, constant: -22),
            mainStackView1.heightAnchor .constraint(equalToConstant:CGFloat(Float(view.frame.height)/2)),
            mainStackView1.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            mainStackView2.heightAnchor.constraint(equalToConstant:CGFloat(Float(view.frame.height)/1.9)),
            mainStackView2.topAnchor.constraint(equalTo: mainStackView1.bottomAnchor),
    //        mainStackView2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackView2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            bodyStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0)
        ])
        
        addTargetsToButtons()

        navigationItem.titleView = logo
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        
    }
    
    
    
    private func addTargetsToButtons(){
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteLeft(_:)), for: .touchUpInside)
        equalsButton.addTarget(self, action: #selector(equalButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "clock.arrow.circlepath"),
//            image: UIImage(systemName: "chevron.left"),
            style: .done,
            target: self,
            action: #selector(goToHistoryPage)
//           action: #selector(exitApp)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "sun.max"),
            style: .plain,
            target: self,
//            action: #selector(gotoHistorypage)
            action: #selector(changeTheme)
        )
    }

    private func createValueButton(value: String, backgroundColor: UIColor, fontColor: UIColor, fontSize: Int = 35) -> UIButton {
        let button = UIButton()
//        button.titleLabel?.font = UIFont(name: "ZohoPuvi-Medium", size: CGFloat(fontSize))
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(fontSize))
        button.setTitle(value, for: .normal)
        button.backgroundColor = backgroundColor
        button.widthAnchor.constraint(equalToConstant: CGFloat(CalculatorViewController.buttonWidth)).isActive = true
        button.heightAnchor.constraint(equalToConstant: CGFloat(CalculatorViewController.buttonHeight)).isActive = true
        button.setTitleColor(fontColor, for: .normal)
        button.tintColor = fontColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(valueButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    

    private func createSymbolButton(symbol: String, backgroundColor: UIColor, fontColor: UIColor) -> UIButton {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: symbol, withConfiguration: config), for: .normal)
        button.backgroundColor = backgroundColor
        button.widthAnchor.constraint(equalToConstant: CGFloat(CalculatorViewController.buttonWidth)).isActive = true
        button.heightAnchor.constraint(equalToConstant: CGFloat(CalculatorViewController.buttonHeight)).isActive = true
        button.tintColor = fontColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    private func createSubStackViews(array: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: array)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func updateMainLabel(){
        mainLabel.text = expression
    }
    private func addToExpression(value: String) {
        if expression == "0" {
            expression = value
        } else {
            expression += value
        }
        
        if isValidExpression(expression) {
            let result = getResult()
            self.result = String(describing: result)
        } else {
            result = "0"
        }
    }

    private func isValidExpression(_ expression: String) -> Bool {
        let operators = CharacterSet(charactersIn: "+-*/")
        var openParentheses = 0
        var closeParentheses = 0
        
        for (index, char) in expression.enumerated() {
            if char == "(" {
                openParentheses += 1
            } else if char == ")" {
                closeParentheses += 1
            }
            
            if operators.contains(char.unicodeScalars.first!) {
                if index == 0 || index == expression.count - 1 { return false }
                
                if let prevChar = expression.dropLast(expression.count - index).last,
                   operators.contains(prevChar.unicodeScalars.first!) { return false }
            }
        }
        
        return openParentheses == closeParentheses
    }

    private func getResult() -> Any {
        let decimalExpression = expression.replacingOccurrences(of: "(\\d+)", with: "$1.0", options: .regularExpression)
        let expressionToEvaluate = NSExpression(format: decimalExpression)
        
        if expression.contains("/0") {
            return Double.nan
        }
        
        if let result = expressionToEvaluate.expressionValue(with: nil, context: nil) as? Double {
            return result.truncatingRemainder(dividingBy: 1) == 0 ? Int(result) : result
        }
        return 0
    }
    
    
    @objc private func valueButtonTapped(_ sender: UIButton) {
        addToExpression(value: sender.titleLabel?.text ?? "")
        let oldColor = sender.backgroundColor
        UIView.animate(withDuration: 0.1) {
            sender.backgroundColor = .darkerBack
        }
        UIView.animate(withDuration: 0.1) {
            sender.backgroundColor = oldColor
        }
    }
    
    @objc private func clear(_ sender: UIButton) {
        expression = "0"
        result = "0"
    }
    
    @objc private func deleteLeft(_ sender: UIButton) {
        guard var text = mainLabel.text, !text.isEmpty else { return }
        text.removeLast()
        expression = text
        if expression.isEmpty { clear(sender) }
    }
    
    @objc private func equalButtonTapped() {
        if isValidExpression(expression) {
            let result = getResult()
            self.result = String(describing: result)
            addToHistory()
        } else {
            result = "Error"
        }
    }
    
    @objc func updateResultLabel(){
        resultLabel.text = result
    }
    
    @objc private func exitApp() {
        exit(0)
    }

    @objc func changeTheme() {
        CalculatorViewController.theme.toggle()
        UIView.animate(withDuration:  0.5) {
            self.view.backgroundColor = CalculatorViewController.theme ? .darkBack : .lightBack
            
            self.navigationItem.rightBarButtonItem?.tintColor = CalculatorViewController.theme ? .white : .lightBrown
            self.navigationItem.leftBarButtonItem?.tintColor = CalculatorViewController.theme ? .white : .lightBrown
            self.logo.textColor = CalculatorViewController.theme ? .white : .lightBrown
        }
        for stack in self.mainStackView2.arrangedSubviews {
            if let subStack = stack as? UIStackView {
                for button in subStack.arrangedSubviews {
                    if let btn = button as? UIButton {
                        UIView.animate(withDuration:  0.5) {
                            btn.backgroundColor = CalculatorViewController.theme ? .darkBack : .lightBack
                            btn.titleLabel?.textColor = CalculatorViewController.theme ? .white : .lightOrange
                            self.mainLabel.textColor = CalculatorViewController.theme ? .white : .lightOrange
                            self.resultLabel.textColor = CalculatorViewController.theme ? .symbolPurple : .lightBrown
                        }
                        
                        if[self.divideButton,self.multiplyButton,self.minusButton,self.plusButton].contains(btn){
                            UIView.animate(withDuration:  0.5) {
                                btn.backgroundColor = CalculatorViewController.theme ? .darkButtonPurple : .lightButtonPurple
                                btn.titleLabel?.textColor = CalculatorViewController.theme ? .symbolPurple : .lightBrown
                            }
                                
                        }else if [self.deleteButton, self.clearButton,self.dotButton,self.openBracketsButton,self.closeBracketsButton, self.closeBracketsButton].contains(btn){
                            UIView.animate(withDuration:  0.5) {
                                btn.titleLabel?.textColor = CalculatorViewController.theme ? .symbolPurple : .lightBrown
                                btn.tintColor = CalculatorViewController.theme ? .symbolPurple : .lightBrown
                            }
                        }
                        else if btn == self.equalsButton{
                            UIView.animate(withDuration:  0.5) {btn.backgroundColor = CalculatorViewController.theme ? .darkEqualsPurple : .lightEqualsPurple
                                btn.titleLabel?.textColor = .white
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func goToHistoryPage() {
            let historyVC = HistoryViewController()
            navigationController?.pushViewController(historyVC, animated: true)
        }
    
    @objc func addToHistory() {
        let object = [
            "Expression": expression,
            "Result": result
        ]
        CalculatorViewController.history.insert(object, at: 0)
//        print(object)
    }

}

extension UIColor {
    static let darkBack = UIColor(red: 0.21, green: 0.18, blue: 0.24, alpha: 1.0)
    static let darkerBack = UIColor(red: 0.16, green: 0.14, blue: 0.18, alpha: 1.0)
    static let darkButtonPurple = UIColor(red: 0.24, green: 0.16, blue: 0.33, alpha: 1.0)

    static let darkEqualsPurple = UIColor(red: 0.42, green: 0.00, blue: 1.00, alpha: 1.0)
    
    //    static let lightBack = UIColor(red: 0.85, green: 0.79, blue: 0.94, alpha: 1.0)
    //    static let lightButtonPurple = UIColor(red: 0.90, green: 0.70, blue: 0.94, alpha: 1.0)
    
    static let lightBack = UIColor(red: 1.00, green: 0.96, blue: 0.92, alpha: 1.0)          // Warmer white
    static let lightButtonPurple = UIColor(red: 0.98, green: 0.92, blue: 0.84, alpha: 1.0)  // Soft peach
    static let lightEqualsPurple = UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0)  // Orange
    static let lightOrange = UIColor(red: 0.80, green: 0.45, blue: 0.12, alpha: 1.0)        // Burnt orange
    static let lightBrown = UIColor(red: 0.40, green: 0.26, blue: 0.13, alpha: 1.0)         // Coffee brown
    static let symbolPurple = UIColor(red: 135/255, green: 77/255, blue: 241/255, alpha: 1.0)
}

//extension UIView {
//    func addSubviews(_ views: UIView...) {
//        views.forEach { self.addSubview($0) }
//    }
//}
//
#Preview{
    CalculatorViewController()
}
