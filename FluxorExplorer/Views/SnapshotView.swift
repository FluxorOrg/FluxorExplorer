//
//  SnapshotView.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 21/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import FluxorExplorerSnapshot
import SwiftUI

struct SnapshotView {
    var snapshot: FluxorExplorerSnapshot
    @State private var selectorIndex = 0
}

extension SnapshotView: View {
    var body: some View {
        VStack {
            Picker("", selection: $selectorIndex) {
                ForEach(0 ..< SnapshotDataType.allCases.count) { index in
                    Text(SnapshotDataType.allCases[index].title).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
            if selectorIndex == SnapshotDataType.action.rawValue {
                Text(snapshot.actionData.name)
                Text(actionPayloadJSON)
            } else if selectorIndex == SnapshotDataType.state.rawValue {
                Text("State")
            } else if selectorIndex == SnapshotDataType.diff.rawValue {
                Text("Diff")
            }
            Spacer()
        }
    }
    
    var actionPayloadJSON: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return String(data: try! encoder.encode(snapshot.actionData.payload), encoding: .utf8)!
    }
}

enum SnapshotDataType: Int, CaseIterable {
    case action
    case state
    case diff

    var title: String {
        switch self {
        case .action:
            return "Action"
        case .state:
            return "State"
        case .diff:
            return "Diff"
        }
    }
}
