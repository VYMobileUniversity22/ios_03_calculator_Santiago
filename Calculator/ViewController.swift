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
        hideButton(hide: hide)
    }

    let defaults = UserDefaults.standard
    @IBOutlet var resultLabel: UILabel!
    // Numbers
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    @IBOutlet var btn5: UIButton!
    @IBOutlet var btn6: UIButton!
    @IBOutlet var btn7: UIButton!
    @IBOutlet var btn8: UIButton!
    @IBOutlet var btn9: UIButton!
    @IBOutlet var btn0: UIButton!
    @IBOutlet var btnDecimal: UIButton!

    // Operators
    @IBOutlet var btnRestart: UIButton!
    @IBOutlet var btnDiv: UIButton!
    @IBOutlet var btnMult: UIButton!
    @IBOutlet var btnRes: UIButton!
    @IBOutlet var btnSum: UIButton!
    @IBOutlet var btnPorcent: UIButton!
    @IBOutlet var btnEqual: UIButton!

    var result: Double = 0
    var actual: Double = 0
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

    // Formateo de valores
    let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        return formatter
    }()

    // Formatear valores por defecto
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
        let currentActual = auxFormatter.string(from: NSNumber(value: actual))!
        if !operating && currentActual.count >= maxLenght {
            return
        }
        resultLabel.text = resultLabel.text! + (kdecimalSeparator ?? "")
        decimal = true
    }

    @IBAction func numberAction(_ sender: UIButton) {
        btnRestart.setTitle("C", for: .normal)

        var currentActual = auxFormatter.string(from: NSNumber(value: actual))!
        if !operating && currentActual.count >= maxLenght {
            return
        }

        if operating {
            result = result == 0 ? actual : result
            resultLabel.text = ""
            currentActual = ""
            operating = false
        }

        if decimal {
            currentActual = "\(currentActual)\(kdecimalSeparator ?? "")"
            decimal = false
        }

        let number = sender.tag
        actual = Double(currentActual + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: actual))
    }

    // Clean vals
    func clear() {
        operation = .none
        btnRestart.setTitle("AC", for: .normal)
        if actual != 0 {
            actual = 0
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
            result = result + actual
            break
        case .res:
            result = result - actual
            break
        case .mult:
            result = result * actual
            break
        case .div:
            result = result / actual
            break
        case .percent:
            actual = actual / 100
            result = actual
        }

        if result <= maxValue || result >= minValue {
            resultLabel.text = printFormatter.string(from: NSNumber(value: result))
        }

        defaults.set(result, forKey: "resultado")
    }
    
    //Func hide button
    func hideButton(hide: Bool) {
        btnDecimal.isHidden = hide
    }
}
