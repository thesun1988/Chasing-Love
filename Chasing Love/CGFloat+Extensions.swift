

import CoreGraphics

let π = CGFloat(M_PI)

public extension CGFloat {

    public static func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    public static func random(min : CGFloat, max : CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }

    public func degreesToRadians() -> CGFloat {
        return π * self / 180.0
    }

    public func radiansToDegrees() -> CGFloat {
        return self * 180.0 / π
    }

}
