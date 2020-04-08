/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

#if DEBUG
import Fluxor
import FluxorExplorerSnapshot
import MultipeerConnectivity

func setupMockData() {
    let peer1 = MCPeerID(displayName: "Peer 1")
    let peer2 = MCPeerID(displayName: "Peer 2")
    Current.store.register(reducer: createReducer(
        reduceOn(ResetStateAction.self) { state, _ in
            state = AppState()
        }
    ))
    Current.store.dispatch(action: ResetStateAction())
    Current.store.dispatch(action: PeerConnectedAction(peer: peer1))
    Current.store.dispatch(action: PeerConnectedAction(peer: peer2))
    Current.store.dispatch(action: DidReceiveSnapshotAction(
        peer: peer1,
        snapshot: FluxorExplorerSnapshot(action: TestAction(increment: 1),
                                         oldState: TestState(counter: 1),
                                         newState: TestState(counter: 2))))
}

private struct TestState: Encodable {
    let counter: Int
}

private struct TestAction: Action {
    let increment: Int
}

private struct ResetStateAction: Action {}
#endif
