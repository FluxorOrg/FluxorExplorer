//
//  SnapshotView.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 21/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import Fluxor
import FluxorExplorerSnapshot
import SwiftUI

struct SnapshotView {
    var snapshot: FluxorExplorerSnapshot

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .long
        return dateFormatter
    }()
}

extension SnapshotView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Time:")
                    .font(.headline)
                Text(dateFormatter.string(from: snapshot.date))
                Divider()
                    .padding(.vertical)

                if snapshot.actionData.payload != nil {
                    Text("Payload")
                        .font(.headline)
                    DataStructureView(dataStructure: snapshot.actionData.payload!)
                        .padding(.top)
                    Divider()
                        .padding(.vertical)
                }

                Text("State")
                    .font(.headline)
                DataStructureView(dataStructure: snapshot.newState)
                    .padding(.top)
                Spacer()
            }
        }
        .navigationBarTitle(snapshot.actionData.name)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

struct SnapshotView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotView(snapshot: FluxorExplorerSnapshot(action: TestAction(increment: 1295),
                                                      oldState: ["counter": 42],
                                                      newState: ["counter": 1337]))
    }

    struct TestAction: Action {
        let increment: Int
    }
}
