//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import MultipeerConnectivity
import Core

protocol SessionServerDelegate: AnyObject {
    func sessionServerDidUpdateConnectedPeers(_ sessionServer: SessionServer)
}

final class SessionServer: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {

    var isPeerConnected: Bool {
        return self.remotePeers.isEmpty == false
    }

    weak var delegate: SessionServerDelegate?

    override init() {
        self.session = MCSession(peer: self.localPeerID)
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.localPeerID, discoveryInfo: nil, serviceType: IBAARVisualizerServiceType)

        super.init()

        self.session.delegate = self
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
    }

    func sendMessage(_ message: ServerMessage) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.requiresSecureCoding = true
        archiver.outputFormat = .binary
        archiver.encode(message, forKey: NSKeyedArchiveRootObjectKey)
        archiver.finishEncoding()

        self.sendData(data as Data)
    }

    func sendData(_ data: Data, reliably: Bool = true) {
        guard self.remotePeers.isEmpty == false else {
            return
        }
        
        try! self.session.send(data, toPeers: self.remotePeers, with: reliably ? .reliable : .unreliable)
    }

    // MARK: - MCSessionDelegate

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if peerID != self.localPeerID {
            DispatchQueue.main.async {
                self.delegate?.sessionServerDidUpdateConnectedPeers(self)
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        assertionFailure("Receiving messages is not supported")
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

    // MARK: - MCNearbyServiceAdvertiserDelegate

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Connecting peer \(peerID.displayName).")
        invitationHandler(true, self.session)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        assertionFailure("Failed to start advertising: \(error).")
    }

    // MARK: - Private

    private let localPeerID = MCPeerID(displayName: UserDefaults.standard.localPeerID)
    private let session: MCSession
    private let advertiser: MCNearbyServiceAdvertiser

    private var remotePeers: [MCPeerID] {
        return self.session.connectedPeers.filter { $0 != self.localPeerID }
    }

}

// MARK: - Private extensions

private extension UserDefaults {

    private enum Keys: String {
        case localPeerID
    }

    var localPeerID: String {
        if let persistedID = self.string(forKey: Keys.localPeerID.rawValue) {
            return persistedID
        } else {
            let id = UUID().uuidString
            self.set(id, forKey: Keys.localPeerID.rawValue)
            return id
        }
    }

}
