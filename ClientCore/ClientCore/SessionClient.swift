//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import MultipeerConnectivity
import Core

protocol SessionClientDelegate: class {
    func sessionClientDidConnectToServer(_ client: SessionClient)
    func sessionClientDidDisconnectFromServer(_ client: SessionClient)
    func sessionClient(_ client: SessionClient, didReceive message: ServerMessage)
}

final class SessionClient: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate {

    weak var delegate: SessionClientDelegate?

    override init() {
        self.session = MCSession(peer: self.localPeerID)
        self.browser = MCNearbyServiceBrowser(peer: self.localPeerID, serviceType: IBAARVisualizerServiceType)

        super.init()

        self.session.delegate = self
        self.browser.delegate = self
        self.browser.startBrowsingForPeers()
    }

    // MARK: - MCSessionDelegate

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            if peerID == self.currentServerID {
                self.currentServerID = nil
                print("Peer \(peerID.displayName) disconnected.")

                DispatchQueue.main.async {
                    self.delegate?.sessionClientDidDisconnectFromServer(self)
                }
            }

        case .connecting:
            if self.currentServerID == nil || self.currentServerID == peerID {
                self.currentServerID = peerID
                print("Peer \(peerID.displayName) is connecting...")
            } else {
                self.session.cancelConnectPeer(peerID)
            }

        case .connected:
            if peerID == self.currentServerID {
                print("Peer \(peerID.displayName) is connected.")

                DispatchQueue.main.async {
                    self.delegate?.sessionClientDidConnectToServer(self)
                }
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard peerID == self.currentServerID else {
            return
        }

        let decodedMessage: ServerMessage?
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            if let message = try unarchiver.decodeTopLevelObject(of: ServerMessage.self, forKey: NSKeyedArchiveRootObjectKey) {
                decodedMessage = message
            } else {
                print("Failed to decode data message: root object is absent!")
                decodedMessage = nil
            }
        } catch {
            print("Failed to decode data message: \(error)")
            decodedMessage = nil
        }

        if let message = decodedMessage {
            self.delegate?.sessionClient(self, didReceive: message)
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        assertionFailure("Receiving streams is not supported")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        assertionFailure("Receiving resources is not supported")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        assertionFailure("Receiving resources is not supported")
    }

    // MARK: - MCNearbyServiceBrowserDelegate

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if self.currentServerID == nil {
            print("Inviting peer \(peerID.displayName)")
            self.browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 5.0)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // No actions
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        assertionFailure("Failed to start browsing: \(error).")
    }

    // MARK: - Private

    private let localPeerID = MCPeerID(displayName: UUID().uuidString)
    private let session: MCSession
    private let browser: MCNearbyServiceBrowser

    private var currentServerID: MCPeerID?

}
