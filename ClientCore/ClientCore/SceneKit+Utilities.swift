//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

extension SCNVector3 {

    static prefix func - (vector: SCNVector3) -> SCNVector3 {
        return SCNVector3(x: -vector.x, y: -vector.y, z: -vector.z)
    }

    static func + (lho: SCNVector3, rho: SCNVector3) -> SCNVector3 {
        return SCNVector3(lho.x + rho.x, lho.y + rho.y, lho.z + rho.z)
    }

    static func - (lho: SCNVector3, rho: SCNVector3) -> SCNVector3 {
        return lho + (-rho)
    }

    static func * (lho: SCNVector3, rho: SCNFloat) -> SCNVector3 {
        return SCNVector3(lho.x * rho, lho.y * rho, lho.z * rho)
    }

}

extension SCNQuaternion {

    static let identity = SCNQuaternion(GLKQuaternionIdentity)

    init(_ quaternion: GLKQuaternion) {
        let (x, y, z, w) = quaternion.q
        self.init(x, y, z, w)
    }

    init(angle: Float, axis: SCNVector3) {
        self.init(GLKQuaternionMakeWithAngleAndAxis(angle, Float(axis.x), Float(axis.y), Float(axis.z)))
    }

}
