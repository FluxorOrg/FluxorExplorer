/**
 * FluxorExplorerInterceptorTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorerInterceptor
import FluxorExplorerSnapshot
import MultipeerConnectivity
import XCTest

class FluxorExplorerInterceptorTests: XCTestCase {
    var interceptor: FluxorExplorerInterceptor<State>!
    var localPeerID: MCPeerID!
    var otherPeerID: MCPeerID!
    var session: MCSession!

    override func setUp() {
        super.setUp()
        interceptor = FluxorExplorerInterceptor(displayName: "MyDevice", advertiserType: TestAdvertiser.self)
        localPeerID = MCPeerID(displayName: "MyDevice")
        otherPeerID = MCPeerID(displayName: "OtherDevice")
        session = MCSession(peer: otherPeerID, securityIdentity: nil, encryptionPreference: .none)
    }

    func testPublicInitializer() {
        // Given
        let publicInterceptor = FluxorExplorerInterceptor<State>(displayName: "MyDevice")
        // Then
        XCTAssertFalse(publicInterceptor.advertiser is TestAdvertiser)
    }

    func testInternalInitializer() {
        // Given
        let testAdvertiser = interceptor!.advertiser as! TestAdvertiser
        // Then
        XCTAssertTrue(testAdvertiser.didStartAdvertisingPeer)
    }

    func testAdvertiserInvitation() {
        // Given
        let acceptedExpectation = expectation(description: debugDescription)
        // When
        var sessionFromInvitation: MCSession?
        interceptor!.advertiser(interceptor!.advertiser, didReceiveInvitationFromPeer: otherPeerID, withContext: nil) { accepted, session in
            XCTAssertTrue(accepted)
            sessionFromInvitation = session
            acceptedExpectation.fulfill()
        }
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(interceptor!.session, sessionFromInvitation)
    }

    func testDefaultPeerDidDisconnect() {
        // When
        interceptor!.session(session, peer: otherPeerID, didChange: MCSessionState.notConnected)
        // Then
        XCTAssertTrue(true) // Nothing explodes (log statement is printed to console)
    }

    func testCustomPeerDidDisconnect() {
        // Given
        let disconnectExpectation = expectation(description: debugDescription)
        interceptor.peerDidDisconnect = { disconnectedPeerID in
            XCTAssertEqual(self.otherPeerID, disconnectedPeerID)
            disconnectExpectation.fulfill()
        }
        // When
        interceptor!.session(session, peer: otherPeerID, didChange: MCSessionState.notConnected)
        // Then
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testUnusedMandatorySessionDelegateCalls() {
        // When
        interceptor!.session(session, didReceive: Data(), fromPeer: otherPeerID)
        interceptor!.session(session, didReceive: InputStream(), withName: "Some name", fromPeer: otherPeerID)
        interceptor!.session(session, didStartReceivingResourceWithName: "Some resource", fromPeer: otherPeerID, with: Progress())
        interceptor!.session(session, didFinishReceivingResourceWithName: "Some resource", fromPeer: otherPeerID, at: nil, withError: nil)
        // Then
        XCTAssertTrue(true) // Nothing explodes
    }

    func testSendSnapshotLaterWhenSessionIsConnected() {
        // Given
        XCTAssertNil(interceptor.session)
        XCTAssertEqual(interceptor.unsentSnapshots.count, 0)
        // When
        let action = TestAction()
        interceptor.actionDispatched(action: action, oldState: State(), newState: State())
        // Then
        XCTAssertEqual(interceptor.unsentSnapshots.count, 1)

        // Given
        let mockSession = MCSessionSubClass(peer: localPeerID, securityIdentity: nil, encryptionPreference: .none, connectedPeers: [otherPeerID])
        interceptor.session = mockSession
        let rawData = try! JSONEncoder().encode(interceptor.unsentSnapshots[0])
        // When
        interceptor.session(interceptor.session!, peer: otherPeerID, didChange: .connected)
        // Then
        let sentData = mockSession.sentData!
        XCTAssertEqual(sentData.data, rawData)
        XCTAssertEqual(sentData.toPeers, [otherPeerID])
        XCTAssertEqual(sentData.mode, .reliable)
        XCTAssertEqual(interceptor.unsentSnapshots.count, 0)
    }

    func testDefaultDidFailSendingSnapshot() {
        // Given
        let snapshot = FluxorExplorerSnapshot(action: TestAction(), oldState: State(), newState: State())
        let mockSession = MCSessionSubClass(peer: localPeerID, securityIdentity: nil, encryptionPreference: .none, connectedPeers: [otherPeerID])
        mockSession.shouldFailSendingData = true
        interceptor.session = mockSession
        // When
        interceptor.send(snapshot: snapshot)
        // Then
        XCTAssertTrue(true) // Nothing explodes (log statement is printed to console)
    }

    func testCustomDidFailSendingSnapshot() {
        // Given
        let snapshot = FluxorExplorerSnapshot(action: TestAction(), oldState: State(), newState: State())
        let mockSession = MCSessionSubClass(peer: localPeerID, securityIdentity: nil, encryptionPreference: .none, connectedPeers: [otherPeerID])
        mockSession.shouldFailSendingData = true
        interceptor.session = mockSession
        let didFailSendingExpectation = expectation(description: debugDescription)
        interceptor.didFailSendingSnapshot = { failingSnapshot in
            XCTAssertEqual(snapshot, failingSnapshot)
            didFailSendingExpectation.fulfill()
        }
        // When
        interceptor.send(snapshot: snapshot)
        // Then
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testNotSendingWhenActionIsUnencodable() {
        // Given
        let action = UnencodableTestAction()
        // When
        interceptor.actionDispatched(action: action, oldState: State(), newState: State())
        // Then
        XCTAssertEqual(interceptor.unsentSnapshots.count, 0)
    }
}

struct TestAction: EncodableAction, Equatable {}
struct UnencodableTestAction: Action {}
struct State: Encodable {}

class TestAdvertiser: MCNearbyServiceAdvertiser {
    var didStartAdvertisingPeer = false

    override func startAdvertisingPeer() {
        didStartAdvertisingPeer = true
    }
}

class MCSessionSubClass: MCSession {
    private(set) var sentData: (data: Data, toPeers: [MCPeerID], mode: MCSessionSendDataMode)?
    private let _connectedPeers: [MCPeerID]
    var shouldFailSendingData = false

    override var connectedPeers: [MCPeerID] { _connectedPeers }

    public init(peer myPeerID: MCPeerID, securityIdentity identity: [Any]?, encryptionPreference: MCEncryptionPreference, connectedPeers: [MCPeerID]) {
        _connectedPeers = connectedPeers
        super.init(peer: myPeerID, securityIdentity: identity, encryptionPreference: encryptionPreference)
    }

    override func send(_ data: Data, toPeers peerIDs: [MCPeerID], with mode: MCSessionSendDataMode) throws {
        if shouldFailSendingData {
            throw MCError(.unknown)
        } else {
            sentData = (data, peerIDs, mode)
        }
    }
}
