/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import AnyCodable
import SwiftUI

struct DataStructureView: View {
    let dataStructure: [String: AnyCodable]

    var body: some View {
        textify(dataStructure, indentation: .init(amount: 0))
            .font(.custom("Lucida Console", size: 16))
    }

    private func textify(_ dictionary: [AnyHashable: AnyCodable],
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
            .sorted { $0.key.description < $1.key.description }
            .compactMap { keyValue -> Text in
                let (key, value) = keyValue
                return Text(subindention.string)
                    + createKeyText(key as! String)
                    + textify(value: value.value, indentation: indentation, afterColon: true)
            }
        let initialText = mappedDictionary.first ?? Text("")
        let formattedDictionary = mappedDictionary.dropFirst().reduce(initialText) { $0 + createNormalText(",\n") + $1 }
        return createNormalText("\(startBraceIndentation.string){\n")
            + formattedDictionary
            + createNormalText("\n\(endBraceIndentation.string)}")
    }

    private func textify(_ array: [Any], indentation: Indentation) -> Text {
        let mappedArray = array.map { element -> Text in
            if let dictionary = element as? [AnyHashable: AnyCodable] {
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
        case let dictionaryValue as [AnyHashable: AnyCodable]:
            valueText = textify(dictionaryValue, indentation: subindentation)
        case let arrayValue as [[AnyHashable: AnyCodable]]:
            valueText = textify(arrayValue, indentation: subindentation)
        case let arrayValue as [AnyCodable]:
            valueText = textify(arrayValue, indentation: subindentation)
        case let arrayValue as [Any]:
            valueText = textify(arrayValue, indentation: subindentation)
        case let anyCodable as AnyCodable:
            valueText = textify(value: anyCodable.value, indentation: indentation, afterColon: afterColon)
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
        Text(string)
    }

    private func createKeyText(_ key: String) -> Text {
        Text("\"\(key)\": ")
            .foregroundColor(Color(.systemOrange))
    }

    private func createValueText(_ value: String) -> Text {
        Text(value)
            .foregroundColor(Color(.systemRed))
    }

    private struct Indentation {
        let amount: Int
        var increased: Indentation { .init(amount: amount + 1) }
        var decreased: Indentation { .init(amount: amount - 1) }
        var string: String { .init(repeating: "    ", count: max(amount, 0)) }
    }
}
