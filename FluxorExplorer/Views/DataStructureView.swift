//
//  DataStructureView.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 12/01/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

import AnyCodable
import SwiftUI

struct DataStructureView: View {
    let dataStructure: [String: AnyCodable]

    var body: some View {
        textify(dataStructure, indentation: .init(amount: 0))
            .font(.custom("Lucida Console", size: 16))
    }

    private func textify(_ dictionary: [String: AnyCodable],
                         indentation: Indentation,
                         startBraceIndentation: Indentation = .init(amount: 0)) -> Text {
        let subindention: Indentation
        let endBraceIndentation: Indentation
        if startBraceIndentation.amount == 0 {
            subindention = indentation.increased
            endBraceIndentation = indentation
        } else {
            subindention = startBraceIndentation.increased
            endBraceIndentation = startBraceIndentation
        }
        let mappedDictionary = dictionary
            .sorted { $0.key < $1.key }
            .compactMap { keyValue -> Text in
                let (key, value) = keyValue
                return Text(subindention.string)
                    + createKeyText(key)
                    + textify(value: value.value, indentation: indentation, afterColon: true)
            }
        let initialText = mappedDictionary.first ?? Text("")
        let formattedDictionary = mappedDictionary.dropFirst().reduce(initialText) { $0 + createNormalText(",\n") + $1 }
        return createNormalText("\(startBraceIndentation.string){\n")
            + formattedDictionary
            + createNormalText("\n\(endBraceIndentation.string)}")
    }

    private func textify(_ dictionary: [String: Any],
                         indentation: Indentation,
                         startBraceIndentation: Indentation = .init(amount: 0)) -> Text {
        return textify(dictionary.mapValues(AnyCodable.init),
                       indentation: indentation,
                       startBraceIndentation: startBraceIndentation)
    }

    private func textify(_ array: [Any], indentation: Indentation) -> Text {
        let mappedArray = array.map { element -> Text in
            if let dictionary = element as? [String: Any] {
                return textify(dictionary, indentation: indentation, startBraceIndentation: indentation.increased)
            } else {
                return textify(value: element, indentation: indentation, afterColon: false)
            }
        }
        let initialText = mappedArray.first ?? Text("")
        let formattedArray = mappedArray.dropFirst().reduce(initialText) { $0 + createNormalText(",\n") + $1 }
        return createNormalText("[\n") + formattedArray + createNormalText("\n\(indentation.string)]")
    }

    private func textify(value: Any, indentation: Indentation, afterColon: Bool) -> Text {
        let subindentation = indentation.increased
        let indentationText = Text(afterColon ? "" : indentation.string)
        let valueText: Text
        switch value {
        case let dictionaryValue as [String: AnyCodable]:
            valueText = textify(dictionaryValue, indentation: subindentation)
        case let dictionaryValue as [String: Any]:
            valueText = textify(dictionaryValue, indentation: subindentation)
        case let arrayValue as [[String: AnyCodable]]:
            valueText = textify(arrayValue, indentation: subindentation)
        case let arrayValue as [AnyCodable]:
            valueText = textify(arrayValue, indentation: subindentation)
        case let arrayValue as [Any]:
            valueText = textify(arrayValue, indentation: subindentation)
        case let stringValue as String:
            valueText = createValueText("\"\(stringValue)\"")
        case let intValue as Int:
            valueText = createValueText("\(intValue)")
        case let doubleValue as Double:
            valueText = createValueText("\(doubleValue)")
        case let boolValue as Bool:
            valueText = createValueText("\(boolValue ? "true" : "false")")
        default:
            valueText = createValueText(String(describing: value))
        }
        return indentationText + valueText
    }

    private func createNormalText(_ string: String) -> Text {
        return Text(string)
    }

    private func createKeyText(_ key: String) -> Text {
        return Text("\"\(key)\": ")
            .foregroundColor(Color(.systemOrange))
    }

    private func createValueText(_ value: String) -> Text {
        return Text(value)
            .foregroundColor(Color(.systemRed))
    }

    struct Indentation {
        let amount: Int
        var increased: Indentation { .init(amount: amount + 1) }
        var decreased: Indentation { .init(amount: amount - 1) }
        var string: String { .init(repeating: "    ", count: max(amount, 0)) }
    }
}
