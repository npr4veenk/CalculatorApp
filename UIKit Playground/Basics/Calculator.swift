import Foundation
import UIKit

enum CalculatorError: Error{
    case invalidInput
    case divisionByZero
}

class Calculator: UIViewController{
    
    var numberField1: UITextField = UITextField()
    var numberField2: UITextField = UITextField()
    var resultLabel: UILabel = UILabel()
    
    func createButton(symbol: String) -> UIButton{
        let button = UIButton()
        button.setImage(UIImage(systemName: symbol), for: .normal)
        button.backgroundColor = .systemBlue
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 10
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }
    
    func createNumField() -> UITextField{
        let numField = UITextField()
        numField.backgroundColor = .systemBackground
        numField.borderStyle = .roundedRect
        numField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        numField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        numField.translatesAutoresizingMaskIntoConstraints = false
        numField.keyboardType = .numberPad
        numField.placeholder = "Enter number 2..."
        
        return numField
    }
    
    func displayResult(content: String){
        resultLabel.text = content
    }
    
    func sum() throws{
        
        guard let value1 = numberField1.text,
              let value2 = numberField2.text,
              let value1 = Int(value1),
              let value2 = Int(value2) else{
            throw CalculatorError.invalidInput
        }
        let result = "Sum: \(value1 + value2)"
        displayResult(content: result)
        print(result)
    }
    
    func difference() throws{
        
        guard let value1 = numberField1.text,
              let value2 = numberField2.text,
              let value1 = Int(value1),
              let value2 = Int(value2) else{
            throw CalculatorError.invalidInput
        }
        let result = "Difference: \(value1 - value2)"
        displayResult(content: result)
        print(result)
    }
    
    func multiply() throws{
        
        guard let value1 = numberField1.text,
              let value2 = numberField2.text,
              let value1 = Int(value1),
              let value2 = Int(value2) else{
            throw CalculatorError.invalidInput
        }
        let result = "Multiplication: \(value1 * value2)"
        displayResult(content: result)
        print(result)
    }
    
    func divide() throws{
        
        guard let value1 = numberField1.text,
              let value2 = numberField2.text,
              let value1 = Int(value1),
              let value2 = Int(value2) else{
            throw CalculatorError.invalidInput
        }
        guard value2 != 0 else{
            throw CalculatorError.divisionByZero
        }
        let result = "Division: \(value1 / value2)"
        displayResult(content: result)
        print(result)
    }
    
    
    @objc func handleSum() {
        do {
            try sum()
        } catch CalculatorError.invalidInput {
            resultLabel.textColor = .red
            displayResult(content: "Error - Invalid input")
        } catch {
            resultLabel.textColor = .red
            displayResult(content: "Error - Division by zero")
        }
    }
    @objc func handleDifference() {
        do {
            try difference()
        } catch CalculatorError.invalidInput {
            resultLabel.textColor = .red
            displayResult(content: "Error - Invalid input")
        } catch {
            resultLabel.textColor = .red
            displayResult(content: "Error - Division by zero")
        }
    }
    @objc func handleMultiplication() {
        do {
            try multiply()
        } catch CalculatorError.invalidInput {
            resultLabel.textColor = .red
            displayResult(content: "Error - Invalid input")
        } catch {
            resultLabel.textColor = .red
            displayResult(content: "Error - Division by zero")
        }
    }
    @objc func handleDivision() {
        do {
            try divide()
        } catch CalculatorError.invalidInput {
            resultLabel.textColor = .red
            displayResult(content: "Error - Invalid input")
        } catch {
            resultLabel.textColor = .red
            displayResult(content: "Error - Division by zero")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let plusButton = createButton(symbol: "plus")
        let minusButton = createButton(symbol: "minus")
        let multiplyButton = createButton(symbol: "multiply")
        let divideButton = createButton(symbol: "divide")

        view.addSubview(plusButton)
        view.addSubview(minusButton)
        view.addSubview(multiplyButton)
        view.addSubview(divideButton)
        
        numberField1 = createNumField()
        numberField2 = createNumField()
        
        let stackView1: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [numberField1, numberField2])
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(stackView)
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            return stackView
        }()
  

        let stackView2: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [plusButton, minusButton, multiplyButton, divideButton])
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(stackView)
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            stackView.axis = .horizontal
            stackView.spacing = 10
            return stackView
        }()
        stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor,constant: 20).isActive = true
        
        plusButton.addTarget(self, action: #selector(handleSum), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(handleDifference), for: .touchUpInside)
        multiplyButton.addTarget(self, action: #selector(handleMultiplication), for: .touchUpInside)
        divideButton.addTarget(self, action: #selector(handleDivision), for: .touchUpInside)
        
        
        resultLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: stackView2.bottomAnchor,constant: 20).isActive = true
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 30)
            label.textColor = .systemBlue
            label.text = "Result"
            return label
        }()
        
        
    }

  
}
//
#Preview{
    Calculator()
}
