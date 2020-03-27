/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import FluxorExplorer
import MultipeerConnectivity.MCPeerID
import XCTest

class MCPeerIDExtensionsTests: XCTestCase {
    func testPeerIDEncodable() throws {
        let peerID = MCPeerID(displayName: "Some peer")
        let jsonEncoder = JSONEncoder()
        let json = try jsonEncoder.encode(peerID)
        XCTAssertEqual(String(data: json, encoding: .utf8), #"{"displayName":"Some peer"}"#)
    }

    func testPeerIDComparable() {
        let peerID1 = MCPeerID(displayName: "Some peer")
        let peerID2 = MCPeerID(displayName: "Another peer")
        let peerID3 = MCPeerID(displayName: "Third peer")
        let peers = [peerID1, peerID2, peerID3]
        XCTAssertEqual(peers.sorted(), [peerID2, peerID1, peerID3])
    }
}
