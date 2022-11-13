//
//  ViewController.swift
//  Calculator
//
//  Created by Santiago Falcon on 8/11/22.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        resultLabel.text = defaults.string(forKey: "resultado")

        let hide = defaults.bool(forKey: "enabled_preference")
    }

    let defaults = UserDefaults.standard
    @IBOutlet var resultLabel: UILabel!
   
    // Operators
    @IBOutlet var btnRestart: UIButton!
    
    var result: Double = 0
    var currentHandler: Double = 0
    var operating = false
    var decimal = false
    var operation: OperationType = .none

    let kdecimalSeparator = Locale.current.decimalSeparator
    let maxLenght = 9
    let maxValue: Double = 999999999
    let minValue: Double = 0.00000001
    enum OperationType {
        case none, sum, res, mult, div, percent
    }

    // Format values
    let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        return formatter
    }()

    // Format values for default
    let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumIntegerDigits = 0
        formatter.maximumIntegerDigits = 8
        return formatter
    }()

    // Actions Operators
    @IBAction func operatorRestart(_ sender: Any) {
        clear()
    }

    @IBAction func operatorDiv(_ sender: UIButton) {
        resultado()
        operating = true
        operation = .div
    }

    @IBAction func operatorMult(_ sender: UIButton) {
        resultado()
        operating = true
        operation = .mult
    }

    @IBAction func operatorRes(_ sender: UIButton) {
        resultado()
        operating = true
        operation = .res
    }

    @IBAction func operatorSum(_ sender: UIButton) {
        resultado()
        operating = true
        operation = .sum
    }

    @IBAction func operatorEqual(_ sender: UIButton) {
        resultado()
    }

    @IBAction func operatorPercent(_ sender: UIButton) {
        operating = true
        operation = .percent
        resultado()
    }

    @IBAction func operatorDecimal(_ sender: UIButton) {
        let currentActual = auxFormatter.string(from: NSNumber(value: currentHandler))!
        if !operating && currentActual.count >= maxLenght {
            return
        }
        resultLabel.text = resultLabel.text! + (kdecimalSeparator ?? "")
        decimal = true
    }

    @IBAction func numberAction(_ sender: UIButton) {
        btnRestart.setTitle("C", for: .normal)

        var currentActual = auxFormatter.string(from: NSNumber(value: currentHandler))!
        if !operating && currentActual.count >= maxLenght {
            return
        }

        if operating {
            result = result == 0 ? currentHandler : result
            resultLabel.text = ""
            currentActual = ""
            operating = false
        }

        if decimal {
            currentActual = "\(currentActual)\(kdecimalSeparator ?? "")"
            decimal = false
        }

        let number = sender.tag
        currentHandler = Double(currentActual + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: currentHandler))
    }

    // Clean values
    func clear() {
        operation = .none
        btnRestart.setTitle("AC", for: .normal)
        if currentHandler != 0 {
            currentHandler = 0
            resultLabel.text = "0"
        } else {
            result = 0
            resultado()
        }
    }
    
    //Cases operators
    func resultado() {
        switch operation {
        case .none:
            // no hara nada
            break
        case .sum:
            result = result + currentHandler
            break
        case .res:
            result = result - currentHandler
            break
        case .mult:
            result = result * currentHandler
            break
        case .div:
            result = result / currentHandler
            break
        case .percent:
            currentHandler = currentHandler / 100
            result = currentHandler
        }

        if result <= maxValue || result >= minValue {
            resultLabel.text = printFormatter.string(from: NSNumber(value: result))
        }

        defaults.set(result, forKey: "resultado")
    }
    
}
