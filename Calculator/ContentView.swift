//
//  ContentView.swift
//  Calculator
//
//  Created by Ömer Köse on 14.09.2021.
//

import SwiftUI

// Buttons in the calculator
enum CalculatorButtons: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case multiply = "X"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    // Arrange colors of the buttons
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return Color(.orange)
        case .clear, .negative, .percent:
            return  Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1)) // Custom dark gray color
        }
    }
}

// Operations that will performed in the calculator
enum Operations {
    case add, subtract, divide, multiply, none
}


struct ContentView: View {
    
    // Initial declarations that will be used in the calculator
    @State var value = "0" // Initial value that will be displayed in the screen as result
    @State var currentOperation: Operations = .none
    @State var runningNumber = 0.0 // This will be used to store the last entered value by the user
    
    var adjuster = buttonAdjuster() // Variable to call the adjuster class

    // Buttons list that will be used in view
    let buttons: [[CalculatorButtons]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/) // Change background color to black, ignoring the safe areas in newer iPhone models
            
            VStack {
                Spacer() // Push everything down to adjust the screen
                HStack {
                    Spacer()
                    Text(self.value)
                        .bold()
                        .font(.system(size: 72))
                        .foregroundColor(.white)
                }
                .padding()
                
                // Implementation of the buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                // Button shapes
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.adjuster.buttonWidth(item: item),
                                        height: self.adjuster.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.adjuster.buttonWidth(item: item) / 2) // To get a better round shape
                            })
                        }
                    }.padding(.bottom, 3) // Vertically space buttons
                }
            }
        }
    }
    
    // Actions that will be executed when user tapped on button
    // This function will store the number than increment it with the entered number
    func didTap(button: CalculatorButtons) {
        switch button {
        // Basic operations
        case .add, .subtract, .multiply,. divide, .equal:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Double(self.value) ?? 0
            } else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Double(self.value) ?? 0
            } else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Double(self.value) ?? 0
            } else if button == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Double(self.value) ?? 0
            } else if button == .equal {
                let runningValue = runningNumber
                let currentValue = Double(self.value) ?? 0
                switch currentOperation {
                case .add:
                    self.value = "\(runningValue + currentValue)"
                case .subtract:
                    self.value = "\(runningValue - currentValue)"
                case .divide:
                    self.value = "\(runningValue / currentValue)"
                case .multiply:
                    self.value = "\(runningValue * currentValue)"
                case .none:
                    break
                }
            }
            // Reset the value
            if button != .equal {
                self.value = "0"
            }
        // Clear Button
        case .clear:
            self.value = "0"
        case .decimal,. negative, .percent:
            break
        // No calculation is made
        default:
            let number = button.rawValue
            if self.value == "0" {
                // Case where user taps on 0
                self.value = number
            } else {
                // When tapped on other buttons
                self.value = "\(self.value)\(number)"
            }
        }
    }
    
    // Class to adjust the shapes of the buttons
    class buttonAdjuster {
        // This function will be adjusting the width of the buttons in the screen,
        // Funciton takes a @item (button) as a parameter
        func buttonWidth(item: CalculatorButtons) -> CGFloat {
            if item == .zero {
                return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
            }
            return(UIScreen.main.bounds.width - (5*12)) / 4
        }
        
        // This function will be adjusting the height of the buttons in the screen,
        // Funciton does not take any parameters as it will be used in all the buttons
        func buttonHeight() -> CGFloat {
            return(UIScreen.main.bounds.width - (5*12)) / 4
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

