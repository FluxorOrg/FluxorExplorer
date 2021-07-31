/**
 * FluxorExplorerSnapshot
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import AnyCodable
import Fluxor
import Foundation

/**
 A representation of a dispatched Action, the old state and the new state.
 To be used by FluxorExplorerInterceptor to send snapshots to FluxorExplorer.
 */
public struct FluxorExplorerSnapshot: Codable, Equatable {
    public let actionData: ActionData
    public let oldState: [String: AnyCodable]
    public let newState: [String: AnyCodable]
    public internal(set) var date: Date

    public init<State: Encodable>(action: Action, oldState: State, newState: State, date: Date = .init()) {
        actionData = .init(action)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        // swiftlint:disable force_try
        let encodedOldState = try! encoder.encode(oldState)
        self.oldState = try! decoder.decode([String: AnyCodable].self, from: encodedOldState)
        let encodedNewState = try! encoder.encode(newState)
        self.newState = try! decoder.decode([String: AnyCodable].self, from: encodedNewState)
        // swiftlint:enable force_try
        self.date = date
    }

    enum CodingKeys: String, CodingKey {
        case date
        case actionData = "action"
        case oldState
        case newState
    }

    /// A `Codable` representation of an `Action` and its payload.
    public struct ActionData: Codable, Equatable {
        public let name: String
        public let payload: [String: AnyCodable]?

        public init(_ action: Action) {
            name = String(describing: type(of: action))
            if let encodableAction = action as? EncodableAction,
               let encodedAction = encodableAction.encode(with: JSONEncoder()),
               let decodedPayload = try? JSONDecoder().decode([String: AnyCodable].self, from: encodedAction),
               decodedPayload.count > 0
            {
                payload = decodedPayload
            }
            else {
                payload = ["error": "Action is not encodable and couldn't be encoded."]
            }
        }
    }
}
