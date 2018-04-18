

import CoreGraphics

public extension Int {

    public static func random(_ n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }

    public static func random(min: Int, max: Int) -> Int {
        assert(min < max)
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}

