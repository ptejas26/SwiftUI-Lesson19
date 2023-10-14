//
//  ContentView.swift
//  Lesson-19-converter
//
//  Created by Tejas Patelia on 2023-09-29.
//

import SwiftUI

extension String {
    var doubleDigitRound: String {
        String(round(100 * (Double(self) ?? 0.0)) / 100)
    }
}

extension String {
    func convertTemp(firstSelection: Temperatures, secondSelection: Temperatures) -> String {

        if self == "" { return ""}

        switch (firstSelection, secondSelection) {
        case (.celsius, .fahrenheit):
            let value = Double((Double(self) ?? 0.0) * 9/5.0)
            return String(value + 32).doubleDigitRound
        case (.celsius, .kelvin):
            return String((Double(self) ?? 0.0) + 273.15).doubleDigitRound

        case (.fahrenheit, .celsius):
            let value = Double((Double(self) ?? 0.0) * 5/9.0)
            return String(value - 32).doubleDigitRound
        case (.fahrenheit, .kelvin):
            let value = Double((Double(self) ?? 0.0) * 5/9.0)
            return String((value - 32) + 273.15).doubleDigitRound
        default: break
        }
        return ""
    }
}

enum Temperatures: String, CaseIterable {
    case celsius
    case fahrenheit
    case kelvin
}

struct ContentView: View {
    let tempConverter = Temperatures.allCases
    let lengthConverter = ["meters", "kilometers", "feet", "yards", "miles"]

    @State var firstSelection: Temperatures = .celsius
    @State var secondSelection: Temperatures = .celsius

    @State var firstText: String = ""
    @State var secondText: String = ""
    @State var firstTextTemp: String = ""
    @State var secondTextTemp: String = ""

    @State var firstTyping: Bool = false
    @State var secondTyping: Bool = false

    var body: some View {
        NavigationView {
            Form {
                HStack {
                    TextField("Enter Value 1", text: $firstText, onEditingChanged: { typing in
                        firstTyping = typing
                        firstTextTemp = firstText

                    })
                    .keyboardType(.numberPad)
                    .onChange(of: firstTyping ? firstText : firstTextTemp, perform: { newValue in
                        secondText =
                        (firstTyping ? firstText : firstTextTemp).convertTemp(firstSelection: firstSelection, secondSelection: secondSelection)
                    })

                    Picker("", selection: $firstSelection) {
                        ForEach(tempConverter, id: \.self) { temp in
                            Text(temp.rawValue.capitalized)
                        }
                    }
                    .onChange(of: firstSelection) { newValue in
                        firstText = secondText.convertTemp(firstSelection: firstSelection, secondSelection: secondSelection)
                    }
                }
                HStack {
                    TextField("Enter Value 2", text: $secondText, onEditingChanged: { typing in
                        secondTyping = typing
                        secondTextTemp = secondText

                    })
                        .keyboardType(.numberPad)
                        .onChange(of: secondTyping ? secondText : secondTextTemp, perform: { newValue in
                            firstText =
                            (secondTyping ? secondText : secondTextTemp).convertTemp(firstSelection: firstSelection, secondSelection: secondSelection)
                        })

                    Picker("", selection: $secondSelection) {
                        ForEach(tempConverter, id: \.self) { temp in
                            Text(temp.rawValue.capitalized)
                        }
                    }
                    .onChange(of: secondSelection) { newValue in
                        secondText = firstText.convertTemp(firstSelection: firstSelection, secondSelection: secondSelection)
                    }
                }
            }

        }.navigationTitle("Converter")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
